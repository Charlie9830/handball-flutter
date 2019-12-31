import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/configValues.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/globals.dart';
import 'package:handball_flutter/models/AccountConfig.dart';
import 'package:handball_flutter/models/Comment.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/ProjectIdModel.dart';
import 'package:handball_flutter/models/ProjectInvite.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/redux/asyncActions.dart';
import 'package:handball_flutter/redux/syncActions.dart';
import 'package:handball_flutter/utilities/Reminders/syncRemindersToDeviceNotifications.dart';
import 'package:handball_flutter/utilities/firestoreSubscribers.dart';
import 'package:handball_flutter/utilities/quickActionsLayer/quickActionsLayer.dart';
import 'package:handball_flutter/utilities/taskAnimationHelpers.dart';
import 'package:redux/redux.dart';

void handleTasksSnapshot(
  TasksSnapshotType type,
  QuerySnapshot snapshot,
  String originProjectId,
  Store<AppState> store,
) {
  var tasks = <TaskModel>[];
  var flaggedAsDeletedTasks = <String, TaskModel>{};

  snapshot.documents.forEach((doc) {
    // **** TO FUTURE SELF *******
    // If you add another condition that causes a task to be filtered out here, you will cause problems with _getGroupedTaskDocumentChanges,
    // Specifically when it is sorting through the modifcations looking for tasks that have been un-deleted. There is a note already there on how to
    // work aroound this.
    if (doc.data['isDeleted'] == true) {
      flaggedAsDeletedTasks[doc.documentID] =
          TaskModel.fromDoc(doc, store.state.user.userId);
    } else {
      tasks.add(TaskModel.fromDoc(doc, store.state.user.userId));
    }
  });

  // Reminder Notification Sync
  if (type == TasksSnapshotType.incompleted) {
    syncRemindersToDeviceNotifications(
        notificationsPlugin,
        snapshot.documentChanges,
        store.state.tasksById,
        store.state.user.userId);
  }

  if (store.state.selectedProjectId == originProjectId && store.state.inflatedProject != null) {
    // Animation.
    var groupedDocumentChanges = getGroupedTaskDocumentChanges(
        snapshot.documentChanges,
        store.state.inflatedProject,
        flaggedAsDeletedTasks,
        store.state.tasksById);

    var preMutationTaskIndices =
        Map<String, int>.from(store.state.inflatedProject.taskIndices);

    if (type == TasksSnapshotType.incompleted) {
      store.dispatch(ReceiveIncompletedTasks(
          tasks: tasks, originProjectId: originProjectId));
    }

    if (type == TasksSnapshotType.completed) {
      store.dispatch(ReceiveCompletedTasks(
          tasks: tasks, originProjectId: originProjectId));
    }

    // Removal.
    driveTaskRemovalAnimations(getTaskRemovalAnimationUpdates(
        groupedDocumentChanges.removed,
        preMutationTaskIndices,
        store.state.user.userId));

    // Additons.
    driveTaskAdditionAnimations(getTaskAdditionAnimationUpdates(
        groupedDocumentChanges.added, store.state.inflatedProject.taskIndices));
  } else {
    // No animation required. Just dispatch the changes to the store.
    if (type == TasksSnapshotType.incompleted) {
      store.dispatch(ReceiveIncompletedTasks(
          tasks: tasks, originProjectId: originProjectId));
    }

    if (type == TasksSnapshotType.completed) {
      store.dispatch(ReceiveCompletedTasks(
          tasks: tasks, originProjectId: originProjectId));
    }
  }
}

void handleTaskListsSnapshot(
    QuerySnapshot snapshot, String originProjectId, Store<AppState> store) {
  var taskLists = <TaskListModel>[];
  var deletedTaskLists = <TaskListModel>[];
  var checklists = <TaskListModel>[];

  snapshot.documents.forEach((doc) {
    var taskList = TaskListModel.fromDoc(doc);

    // Don't add lists Flagged to the main collections. Add them to the deletedMap.
    if (taskList.isDeleted != true) {
      taskLists.add(taskList);

      if (taskList.settings?.checklistSettings?.isChecklist == true) {
        checklists.add(taskList);
      }
    } else {
      deletedTaskLists.add(taskList);
    }
  });

  store.dispatch(
      ReceiveTaskLists(taskLists: taskLists, originProjectId: originProjectId));

  store.dispatch(processChecklists(checklists));

  store.dispatch(ReceiveDeletedTaskLists(
    taskLists: deletedTaskLists,
    originProjectId: originProjectId,
  ));
}

void handleTaskCommentsSnapshot(Store<AppState> store, QuerySnapshot snapshot) {
  // We query for taskCommentQueryLimit + 1 documents. So if we didn't retreive that many documents,
  // then we can guarantee that the Pagination is complete.
  store.dispatch(SetIsTaskCommentPaginationComplete(
      isComplete: snapshot.documents.length < taskCommentQueryLimit + 1));

  List<CommentModel> comments = [];
  snapshot.documents.forEach((doc) => comments.add(CommentModel.fromDoc(doc)));

  var taskComments = store.state.taskComments.toList();
  taskComments.addAll(comments.take(taskCommentQueryLimit));

  store.dispatch(ReceiveTaskComments(taskComments: taskComments));
}

void handleAccountConfigSnapshot(
    DocumentSnapshot docSnapshot, Store<AppState> store) {
  if (docSnapshot.exists) {
    var accountConfig = AccountConfigModel.fromDoc(docSnapshot);
    store.dispatch(ReceiveAccountConfig(accountConfig: accountConfig));
  }
}

void handleProjectInvitesSnapshot(
    QuerySnapshot snapshot, Store<AppState> store) {
  List<ProjectInviteModel> invites = [];
  snapshot.documents
      .forEach((doc) => invites.add(ProjectInviteModel.fromDoc(doc)));

  store.dispatch(ReceiveProjectInvites(invites: invites));
}

void handleProjectIdsSnapshot(QuerySnapshot snapshot, Store<AppState> store) {
  for (var change in snapshot.documentChanges) {
    final projectIdModel = ProjectIdModel.fromDoc(change.document);
    final projectId = projectIdModel.uid;
    final isArchived = projectIdModel.isArchived;
    final isDeleted = projectIdModel.isDeleted;

    if (change.type == DocumentChangeType.added && isArchived == false && isDeleted == false) {
      addProjectSubscription(projectId, store);
    }

    if (change.type == DocumentChangeType.removed) {
      removeProjectSubscription(projectId, store);
    }

    if (change.type == DocumentChangeType.modified) {
      if (isArchived == true || isDeleted == true) {
        removeProjectSubscription(projectId, store);
      } else if (isArchived == false && isDeleted == false) {
        addProjectSubscription(projectId,
            store); // _addProjectSubscription will ignore if we have already added it.
      }
    }
  }

  store.dispatch(ReceiveProjectIds(
      projectIds: snapshot.documents
          .map((doc) => ProjectIdModel.fromDoc(doc))
          .toList()));
}

void handleProjectSnapshot(DocumentSnapshot doc, Store<AppState> store) {
  if (doc.exists) {
    // Filtering of projects with isDeleted flag is handled by the Reducer.
    store.dispatch(ReceiveProject(project: ProjectModel.fromDoc(doc)));
  }
}

void handleMembersSnapshot(QuerySnapshot snapshot, String projectId, Store<AppState> store) {
  List<MemberModel> members = [];
  snapshot.documents.forEach((doc) => members.add(MemberModel.fromDoc(doc)));

  store.dispatch(ReceiveMembers(projectId: projectId, membersList: members));
}