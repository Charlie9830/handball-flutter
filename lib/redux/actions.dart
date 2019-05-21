import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/models/GroupedDocumentChanges.dart';
import 'package:handball_flutter/models/InflatedProject.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/TaskListSettings.dart';
import 'package:handball_flutter/models/TextInputDialogModel.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:handball_flutter/presentation/Dialogs/AddTaskDialog/AddTaskDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/TextInputDialog.dart';
import 'package:handball_flutter/presentation/Task/Task.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class SelectProject {
  final String uid;

  SelectProject(this.uid);
}

class SetUser {
  final User user;

  SetUser({this.user});
}

class ReceiveLocalProjects {
  final List<ProjectModel> projects;

  ReceiveLocalProjects({this.projects});
}

class ReceiveLocalTasks {
  final List<TaskModel> tasks;

  ReceiveLocalTasks({this.tasks});
}

class ReceiveLocalTaskLists {
  final List<TaskListModel> taskLists;

  ReceiveLocalTaskLists({this.taskLists});
}

class NavigateToProject {}

class NavigateToAppDrawer {}

class SetFocusedTaskListId {
  final String taskListId;

  SetFocusedTaskListId({this.taskListId});
}

class SetSelectedTaskEntity {
  final taskEntity;

  SetSelectedTaskEntity({this.taskEntity});
}

class OpenTaskInspector {
  final TaskModel taskEntity;

  OpenTaskInspector({this.taskEntity});
}

class CloseTaskInspector {}

class SetTextInputDialog {
  final TextInputDialogModel dialog;

  SetTextInputDialog({this.dialog});
}

Future<TextInputDialogResult> postTextInputDialog(
    String title, String text, BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => TextInputDialog(title: title, text: text),
  );
}

Future<AddTaskDialogResult> postAddTaskDialog(
    BuildContext context, TaskListModel selectedTaskList,
    {List<TaskListModel> taskLists}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => AddTaskDialog(
          selectedTaskList: selectedTaskList,
          taskLists: taskLists,
        ),
  );
}

Future<DialogResult> postConfirmationDialog(String title, String text,
    String affirmativeText, String negativeText, BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text(negativeText),
                onPressed: () =>
                    Navigator.of(context).pop(DialogResult.negative),
              ),
              FlatButton(
                child: Text(affirmativeText),
                onPressed: () =>
                    Navigator.of(context).pop(DialogResult.affirmative),
              ),
            ]);
      });
}

ThunkAction<AppState> updateTaskPriority(
    bool newValue, String taskId, String projectId) {
  return (Store<AppState> store) async {
    var ref = _getTasksCollectionRef(projectId, store).document(taskId);

    try {
      await ref.updateData({'isHighPriority': newValue});
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> updateTaskNote(
    String newValue, String taskId, String projectId) {
  return (Store<AppState> store) async {
    var ref = _getTasksCollectionRef(projectId, store).document(taskId);
    var coercedValue = newValue ?? '';

    try {
      await ref.updateData({'note': coercedValue});
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> updateTaskDueDate(String taskId, DateTime newValue) {
  return (Store<AppState> store) async {
    var ref = _getTasksCollectionRef(store.state.selectedProjectId, store)
        .document(taskId);
    String coercedValue = newValue == null ? '' : newValue.toIso8601String();

    try {
      await ref.updateData({'dueDate': coercedValue});
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> deleteProjectWithDialog(
    String projectId, String projectName, BuildContext context) {
  return (Store<AppState> store) async {
    var dialogResult = await postConfirmationDialog(
        "Delete Project",
        'Are you sure you want to delete $projectName',
        'Delete',
        'Cancel',
        context);

    if (dialogResult == DialogResult.negative) {
      return;
    }

    var taskIds = _getProjectRelatedTaskIds(projectId, store.state.tasks);
    var taskListIds =
        _getProjectRelatedTaskListIds(projectId, store.state.taskLists);
    var batch = Firestore.instance.batch();
    var userId = store.state.user.userId;

    // Build Tasks into Batch
    for (var id in taskIds) {
      batch.delete(_getTasksCollectionRef(projectId, store).document(id));
    }

    // Build TaskLists into Batch.
    for (var id in taskListIds) {
      batch.delete(_getTaskListsCollectionRef(projectId, store).document(id));
    }

    batch.delete(Firestore.instance
        .collection('users')
        .document(userId)
        .collection('projects')
        .document(projectId));

    try {
      await batch.commit();
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> renameTaskListWithDialog(
    String taskListId, String taskListName, BuildContext context) {
  return (Store<AppState> store) async {
    var userId = store.state.user.userId;
    var dialogResult =
        await postTextInputDialog('Rename List', taskListName, context);

    if (dialogResult.result == DialogResult.negative) {
      return;
    }

    try {
      await _getTaskListsCollectionRef(store.state.selectedProjectId, store)
          .document(taskListId)
          .updateData({'taskListName': dialogResult.value});
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> deleteTaskListWithDialog(
    String taskListId, String taskListName, BuildContext context) {
  return (Store<AppState> store) async {
    var userId = store.state.user.userId;
    var dialogResult = await postConfirmationDialog('Delete List',
        'Are you sure you want to delete $taskListName?', 'Yes', 'No', context);

    if (dialogResult == DialogResult.negative) {
      return;
    }

    try {
      await _deleteTaskList(taskListId, store, userId);
    } catch (error) {
      throw error;
    }
  };
}

Future _deleteTaskList(
    String taskListId, Store<AppState> store, String userId) async {
  var taskIds = _getListRelatedTaskIds(taskListId, store.state.tasks);
  var baseTaskRef =
      _getTasksCollectionRef(store.state.selectedProjectId, store);
  var taskListRef =
      _getTaskListsCollectionRef(store.state.selectedProjectId, store)
          .document(taskListId);
  var batch = Firestore.instance.batch();

  // Delete related Tasks
  for (var id in taskIds) {
    batch.delete(baseTaskRef.document(id));
  }

  // Delete TaskList.
  batch.delete(taskListRef);

  return batch.commit();
}

Iterable<String> _getListRelatedTaskIds(
    String taskListId, List<TaskModel> tasks) {
  return tasks
      .where((task) => task.taskList == taskListId)
      .map((task) => task.uid);
}

Iterable<String> _getProjectRelatedTaskIds(
    String projectId, List<TaskModel> tasks) {
  return tasks
      .where((task) => task.project == projectId)
      .map((task) => task.uid);
}

Iterable<String> _getProjectRelatedTaskListIds(
    String projectId, List<TaskListModel> taskLists) {
  return taskLists
      .where((list) => list.project == projectId)
      .map((list) => list.uid);
}

ThunkAction<AppState> deleteTaskWithDialog(
    String taskId, BuildContext context) {
  return (Store<AppState> store) async {
    var userId = store.state.user.userId;

    try {
      await _getTasksCollectionRef(store.state.selectedProjectId, store)
          .document(taskId)
          .delete();
      print("Task Deleted");
    } catch (error) {
      print(error);
    }
  };
}

ThunkAction<AppState> updateTaskSorting(String projectId, String taskListId,
    TaskListSettingsModel existingSettings, TaskSorting sorting) {
  return (Store<AppState> store) async {
    var ref = _getTaskListsCollectionRef(projectId, store).document(taskListId);
    var newSettings = existingSettings?.copyWith(sortBy: sorting);

    try {
      await ref.updateData({'settings': newSettings.toMap()});
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> addNewProjectWithDialog(BuildContext context) {
  return (Store<AppState> store) async {
    var result = await postTextInputDialog('Add new Project', '', context);

    if (result is TextInputDialogResult &&
        result.result == DialogResult.affirmative) {
      var ref = _getProjectsCollectionRef(store).document();
      var project = ProjectModel(
        uid: ref.documentID,
        projectName: result.value,
        isRemote: false,
        created: DateTime.now().toIso8601String(),
      );

      try {
        await ref.setData(project.toMap());
      } catch (error) {
        throw error;
      }
    }
  };
}

ThunkAction<AppState> addNewTaskListWithDialog(
    String projectId, BuildContext context) {
  return (Store<AppState> store) async {
    var result = await postTextInputDialog('Add new List', '', context);

    if (result is TextInputDialogResult &&
        result.result == DialogResult.affirmative) {
      var ref = _getTaskListsCollectionRef(projectId, store).document();
      var taskList = TaskListModel(
        uid: ref.documentID,
        project: projectId,
        taskListName: result.value,
      );

      try {
        await ref.setData(taskList.toMap());
        print("Success");
      } catch (error) {
        print(error.toString());
      }
    } else {
      print('Canceled');
    }
  };
}

ThunkAction<AppState> updateTaskName(
    String newValue, String taskId, String projectId) {
  return (Store<AppState> store) async {
    var ref = _getTasksCollectionRef(projectId, store).document(taskId);
    try {
      await ref.updateData({'taskName': newValue});
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> addNewTaskWithDialog(
    String projectId, BuildContext context,
    {String taskListId}) {
  return (Store<AppState> store) async {
    var selectedTaskList = taskListId == null || taskListId == '-1'
        ? null
        : store.state.filteredTaskLists
            .firstWhere((item) => item.uid == taskListId, orElse: () => null);

    var result = await postAddTaskDialog(
      context,
      selectedTaskList,
      taskLists: store.state.filteredTaskLists,
    );

    if (result == null) {
      return;
    }

    if (result is AddTaskDialogResult &&
        result.result == DialogResult.affirmative) {
      if (result.isNewTaskList == true) {
        // User has elected to create a new TaskList
        var batch = Firestore.instance.batch();
        var taskListRef =
            _getTaskListsCollectionRef(projectId, store).document();
        var newTaskList = TaskListModel(
          uid: taskListRef.documentID,
          project: projectId,
          taskListName: result.taskListName,
        );

        var taskRef = _getTasksCollectionRef(projectId, store).document();
        var task = TaskModel(
          uid: taskRef.documentID,
          taskList: newTaskList.uid,
          project: projectId,
          taskName: result.taskName,
          dueDate: result.selectedDueDate,
          isHighPriority: result.isHighPriority,
          dateAdded: DateTime.now(),
        );

        batch.setData(taskRef, task.toMap());
        batch.setData(taskListRef, newTaskList.toMap());

        try {
          await batch.commit();
        } catch (error) {
          throw error;
        }
      } else {
        // User selected an existing TaskList.
        var taskRef = _getTasksCollectionRef(projectId, store).document();
        var task = TaskModel(
          uid: taskRef.documentID,
          taskList: result.taskListId ?? taskListId, // Use the taskListId parameter if Dialog returns a null taskListId.
          project: projectId,
          taskName: result.taskName,
          dueDate: result.selectedDueDate,
          isHighPriority: result.isHighPriority,
          dateAdded: DateTime.now(),
        );

        try {
          await taskRef.setData(task.toMap());
        } catch (error) {
          throw error;
        }
      }
    }
  };
}

ThunkAction<AppState> updateTaskComplete(String taskId, bool newValue) {
  return (Store<AppState> store) async {
    var userId = store.state.user.userId;

    await _getTasksCollectionRef(store.state.selectedProjectId, store)
        .document(taskId)
        .updateData({'isComplete': newValue});
  };
}

ThunkAction<AppState> subscribeToLocalTaskLists(String userId) {
  return (Store<AppState> store) async {
    Firestore.instance
        .collection('users')
        .document(userId)
        .collection('taskLists')
        .snapshots()
        .listen((data) {
      var taskLists = <TaskListModel>[];
      data.documents.forEach((doc) {
        taskLists.add(TaskListModel.fromDoc(doc));
      });

      store.dispatch(ReceiveLocalTaskLists(taskLists: taskLists));
    });
  };
}

ThunkAction<AppState> subscribeToLocalTasks(String userId) {
  return (Store<AppState> store) async {
    Firestore.instance
        .collection('users')
        .document(userId)
        .collection('tasks')
        .snapshots()
        .listen((snapshot) {
      var tasks = <TaskModel>[];

      snapshot.documents.forEach((doc) {
        tasks.add(TaskModel.fromDoc(doc));
      });

      // Animation.
      // In order for the correct Index to be found within state.taskIndicies, we have to Process the animation for any removals,
      // then dispatch the changes to the store (So that Task Indices gets reprocessed), then process the additions.
      var groupedDocumentChanges =
          _getGroupedDocumentChanges(snapshot.documentChanges);

      _driveTaskRemovalAnimations(
          store.state.inflatedProject, groupedDocumentChanges.removed);

      store.dispatch(ReceiveLocalTasks(tasks: tasks));

      _driveTaskAdditionAnimations(
          store.state.inflatedProject, groupedDocumentChanges.added);
    });
  };
}

ThunkAction<AppState> subscribeToLocalProjects(String userId) {
  return (Store<AppState> store) async {
    Firestore.instance
        .collection('users')
        .document(userId)
        .collection('projects')
        .snapshots()
        .listen((data) {
      var projects = <ProjectModel>[];
      data.documents.forEach((doc) {
        projects.add(ProjectModel.fromDoc(doc));
      });

      store.dispatch(ReceiveLocalProjects(projects: projects));
    });
  };
}

ThunkAction<AppState> signInUser() {
  return (Store<AppState> store) async {
    print('Signing in User');
    final FirebaseUser user = await auth.signInWithEmailAndPassword(
        email: 'a@test.com', password: 'adingusshrew');

    print('Logged in');

    store.dispatch(SetUser(
        user: new User(
            isLoggedIn: true,
            displayName: user.displayName,
            userId: user.uid,
            email: user.email)));

    store.dispatch(subscribeToLocalProjects(user.uid));
    store.dispatch(subscribeToLocalTasks(user.uid));
    store.dispatch(subscribeToLocalTaskLists(user.uid));
  };
}

bool _isProjectRemote(String projectId, Store<AppState> store) {
  // Todo: Implement this to check if the projectId exists within state.remoteProjectIds. Try not to do it by checking through
  // a collection of remoteProjects and matching ID, as this will likely get called in a lot of loops creating firestore batches
  // and that would mean an O^n operation.
  return false;
}

CollectionReference _getTasksCollectionRef(
    String projectId, Store<AppState> store) {
  if (_isProjectRemote(projectId, store)) {
    throw UnimplementedError();
  } else {
    return Firestore.instance
        .collection('users')
        .document(store.state.user.userId)
        .collection('tasks');
  }
}

CollectionReference _getTaskListsCollectionRef(
    String projectId, Store<AppState> store) {
  if (_isProjectRemote(projectId, store)) {
    throw UnimplementedError();
  } else {
    return Firestore.instance
        .collection('users')
        .document(store.state.user.userId)
        .collection('taskLists');
  }
}

CollectionReference _getProjectsCollectionRef(Store<AppState> store) {
  return Firestore.instance
      .collection('users')
      .document(store.state.user.userId)
      .collection('projects');
}

GroupedDocumentChanges _getGroupedDocumentChanges(
    List<DocumentChange> docChanges) {
  var groupedChanges = GroupedDocumentChanges();

  for (var change in docChanges) {
    if (change.type == DocumentChangeType.removed) {
      groupedChanges.removed.add(change);
    }

    if (change.type == DocumentChangeType.modified) {
      groupedChanges.modified.add(change);
    }

    if (change.type == DocumentChangeType.added) {
      groupedChanges.added.add(change);
    }
  }

  return groupedChanges;
}

void _driveTaskAdditionAnimations(InflatedProjectModel inflatedProject,
    List<DocumentChange> addedDocChanges) {
  if (inflatedProject == null) {
    return;
  }

  for (var docChange in addedDocChanges) {
    if (docChange.type == DocumentChangeType.added) {
      // Determine Destination Index.
      var index = _getTaskAnimationIndex(
          inflatedProject.taskIndices, docChange.document);
      var animatedListStateKey =
          _getAnimatedListStateKey(docChange.document['taskList']);

      if (index == null || animatedListStateKey == null) {
        return;
      }

      animatedListStateKey.currentState.insertItem(index);
    }
  }
}

void _driveTaskRemovalAnimations(InflatedProjectModel inflatedProject,
    List<DocumentChange> removalDocChanges) {
  if (inflatedProject == null) {
    return;
  }

  for (var docChange in removalDocChanges) {
    // Determine Index.
    var task = TaskModel.fromDoc(docChange.document);
    var index =
        _getTaskAnimationIndex(inflatedProject.taskIndices, docChange.document);
    var animatedListStateKey = _getAnimatedListStateKey(task.taskList);

    if (index == null || animatedListStateKey == null) {
      return;
    }

    animatedListStateKey.currentState.removeItem(index, (context, animation) {
      return SizeTransition(
          sizeFactor: animation.drive(Tween(begin: 1, end: 0)),
          axis: Axis.vertical,
          child: Task(
            key: Key(task.uid),
            model: TaskViewModel(data: task),
          ));
    });
  }
}

int _getTaskAnimationIndex(Map<String, int> indices, DocumentSnapshot doc) {
  return indices[doc.documentID];
}

GlobalKey<AnimatedListState> _getAnimatedListStateKey(String taskListId) {
  return taskListAnimatedListStateKeys[taskListId];
}
