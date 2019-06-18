import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handball_flutter/FirestoreStreamsContainer.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/models/ChecklistSettings.dart';
import 'package:handball_flutter/models/DirectoryListing.dart';
import 'package:handball_flutter/models/GroupedDocumentChanges.dart';
import 'package:handball_flutter/models/InflatedProject.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/ProjectIdModel.dart';
import 'package:handball_flutter/models/ProjectInvite.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/TaskListSettings.dart';
import 'package:handball_flutter/models/TextInputDialogModel.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:handball_flutter/presentation/Dialogs/AddTaskDialog/AddTaskDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/ChecklistSettingsDialog/ChecklistSettingsDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/DelegateOwnerDialog/DelegateOwnerDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/TextInputDialog.dart';
import 'package:handball_flutter/presentation/Screens/AppDrawer/ProjectInviteListTile.dart';
import 'package:handball_flutter/presentation/Screens/SignUp/SignUpBase.dart';
import 'package:handball_flutter/presentation/Task/Task.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/utilities/convertMemberRole.dart';
import 'package:handball_flutter/utilities/normalizeDate.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:handball_flutter/utilities/CloudFunctionLayer.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirestoreStreamsContainer _firestoreStreams = FirestoreStreamsContainer();
final CloudFunctionsLayer _cloudFunctionsLayer = CloudFunctionsLayer();

class OpenAppSettings {
  final AppSettingsTabs tab;

  OpenAppSettings({
    this.tab,
  });
}

class CloseAppSettings {}

class SetProcessingProjectInviteIds {
  final List<String> processingProjectInviteIds;

  SetProcessingProjectInviteIds({
    this.processingProjectInviteIds,
  });
}

class SetProcessingMembers {
  final List<String> processingMembers;

  SetProcessingMembers({
    this.processingMembers,
  });
}

class SetIsInvitingUser {
  final bool isInvitingUser;

  SetIsInvitingUser({
    this.isInvitingUser,
  });
}

class ReceiveProjectInvites {
  final List<ProjectInviteModel> invites;

  ReceiveProjectInvites({
    this.invites,
  });
}

class SelectProject {
  final String uid;

  SelectProject(this.uid);
}

class RemoveProjectEntities {
  final String projectId;

  RemoveProjectEntities({this.projectId});
}

class SetAccountState {
  final AccountState accountState;

  SetAccountState({this.accountState});
}

class SignOut {}

class SignIn {
  final User user;

  SignIn({this.user});
}

class ReceiveMembers {
  final String projectId;
  final List<MemberModel> membersList;

  ReceiveMembers({
    this.projectId,
    this.membersList,
  });
}

class ReceiveProject {
  final ProjectModel project;

  ReceiveProject({this.project});
}

class PushLastUsedTaskList {
  final String projectId;
  final String taskListId;

  PushLastUsedTaskList({
    this.projectId,
    this.taskListId,
  });
}

class OpenShareProjectScreen {
  final String projectId;

  OpenShareProjectScreen({this.projectId});
}

class ReceiveTasks {
  final List<TaskModel> tasks;
  final String originProjectId;

  ReceiveTasks({@required this.tasks, @required this.originProjectId});
}

class ReceiveTaskLists {
  final List<TaskListModel> taskLists;
  final String originProjectId;

  ReceiveTaskLists({@required this.taskLists, @required this.originProjectId});
}

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
    {List<TaskListModel> taskLists, bool allowTaskListChange}) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) => AddTaskDialog(
          preselectedTaskList: selectedTaskList,
          taskLists: taskLists,
          allowTaskListChange: allowTaskListChange,
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

Future<void> postAlertDialog(
    String title, String text, String affirmativeText, BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text(affirmativeText),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ]);
      });
}

Future<String> postDelegateOwnerDialog(
    List<MemberModel> nonOwnerMembers, BuildContext context) {
  // Returns userId of selected user or null if User cancelled dialog.
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return DelegateOwnerDialog(members: nonOwnerMembers);
      });
}

ThunkAction<AppState> initializeApp() {
  return (Store<AppState> store) async {
    Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
    auth.onAuthStateChanged.listen((user) => onAuthStateChanged(store, user));
  };
}

void onAuthStateChanged(Store<AppState> store, FirebaseUser user) {
  if (user == null) {
    store.dispatch(SignOut());
    _firestoreStreams.cancelAll();
    return;
  }

  store.dispatch(SignIn(
      user: new User(
          isLoggedIn: true,
          displayName: user.displayName,
          userId: user.uid,
          email: user.email)));

  subscribeToDatabase(store, user.uid);
}

void subscribeToDatabase(Store<AppState> store, String userId) {
  _firestoreStreams.invites = _subscribeToProjectInvites(userId, store);
  _firestoreStreams.projectIds = _subscribeToProjectIds(userId, store);
}

StreamSubscription<QuerySnapshot> _subscribeToProjectInvites(
    String userId, Store<AppState> store) {
  return Firestore.instance
      .collection('users')
      .document(userId)
      .collection('invites')
      .snapshots()
      .listen((snapshot) {
    List<ProjectInviteModel> invites = [];
    snapshot.documents
        .forEach((doc) => invites.add(ProjectInviteModel.fromDoc(doc)));

    store.dispatch(ReceiveProjectInvites(invites: invites));
  });
}


ThunkAction<AppState> acceptProjectInvite(String projectId) {
  return (Store<AppState> store) async {
    addProcessingProjectInviteId(projectId, store);

    try {
      await _cloudFunctionsLayer.acceptProjectInvite(projectId: projectId);
      await _removeProjectInvite(store.state.user.userId, projectId);

      removeProccessingProjectInviteId(projectId, store);
    } catch (error) {
      removeProccessingProjectInviteId(projectId, store);
      throw error;
    }
  };
}

void addProcessingProjectInviteId(String projectId, Store<AppState> store) {
  if (store.state.processingProjectInviteIds.contains(projectId)) {
    return;
  }

  List<String> newList = store.state.processingProjectInviteIds.toList();
  newList.add(projectId);

  store.dispatch(
      SetProcessingProjectInviteIds(processingProjectInviteIds: newList));
}

void removeProccessingProjectInviteId(String projectId, Store<AppState> store) {
  List<String> newList = store.state.processingProjectInviteIds
      .where((item) => item != projectId)
      .toList();

  store.dispatch(
      SetProcessingProjectInviteIds(processingProjectInviteIds: newList));
}

ThunkAction<AppState> denyProjectInvite(String projectId) {
  return (Store<AppState> store) async {
    addProcessingProjectInviteId(projectId, store);
    try {
      await _cloudFunctionsLayer.denyProjectInvite(projectId: projectId);
      await _removeProjectInvite(store.state.user.userId, projectId);
      removeProccessingProjectInviteId(projectId, store);
    } catch (error) {
      removeProccessingProjectInviteId(projectId, store);
      throw error;
    }
  };
}

Future<void> _removeProjectInvite(String userId, String projectId) async {
  var ref = _getInvitesCollectionRef(userId).document(projectId);
  try {
    await ref.delete();
    return;
  } catch (error) {
    throw error;
  }
}

ThunkAction<AppState> inviteUserToProject(
    String email, String sourceProjectId, String projectName, MemberRole role) {
  return (Store<AppState> store) async {
    store.dispatch(SetIsInvitingUser(isInvitingUser: true));
    var response = await _cloudFunctionsLayer.getRemoteUserData(email);

    if (response == null) {
      store.dispatch(SetIsInvitingUser(isInvitingUser: false));
      // No user found.
      // TODO: Implement Firebase Dynamic Links to dispatch an email to the intended user, inviting them to the app.
    }

    try {
      await _cloudFunctionsLayer.sendProjectInvite(
        projectId: sourceProjectId,
        projectName: projectName,
        sourceDisplayName: store.state.user.displayName,
        sourceEmail: store.state.user.email,
        targetDisplayName: response.displayName,
        targetEmail: response.email,
        targetUserId: response.userId,
        role: role,
      );

      store.dispatch(SetIsInvitingUser(isInvitingUser: false));
    } catch (error) {
      store.dispatch(SetIsInvitingUser(isInvitingUser: false));
      throw error;
    }
  };
}

ThunkAction<AppState> signInUser(
    String email, String password, BuildContext context) {
  return (Store<AppState> store) async {
    store.dispatch(SetAccountState(accountState: AccountState.loggingIn));

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      store.dispatch(SetAccountState(accountState: AccountState.loggedOut));
      throw error;
    }
  };
}

ThunkAction<AppState> signOutUser() {
  return (Store<AppState> store) async {
    try {
      auth.signOut();
    } catch (error) {
      throw error;
    }
  };
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

ThunkAction<AppState> leaveSharedProject(String projectId, String projectName,
    List<MemberModel> currentMembers, BuildContext context) {
  return (Store<AppState> store) async {
    var userId = store.state.user.userId;

    // User is the Last Owner. Ensure they delegate another Member to be the Owner before leaving.
    if (_isLastOwner(userId, currentMembers)) {
      String resultUserId = await postDelegateOwnerDialog(
          currentMembers
              .where((item) => item.role == MemberRole.member)
              .toList(),
          context);

      if (resultUserId == null) {
        return;
      }

      try {
        await _promoteUser(userId, projectId);
        await _leaveSharedProject(projectId, store);
        store.dispatch(SelectProject('-1'));
        Navigator.of(context).popUntil((route) => route.isFirst == true);

        return;
      } catch (error) {
        throw error;
      }
    }

    if (currentMembers.length == 1 && currentMembers[0].userId == userId) {
      // This project has never been, or is no longer shared with other users.
      // Delete Project.
      try {
        _deleteProject(projectId, store);
        store.dispatch((SelectProject('-1')));
        Navigator.of(context).popUntil((route) => route.isFirst == true);

        return;
      } catch (error) {
        throw error;
      }
    }

    // Clean Exit from Project.
    var result = await postConfirmationDialog(
        'Leave Project',
        'Are you sure you want to leave $projectName? It will be removed from all of your devices',
        'Leave Project',
        'Cancel',
        context);

    if (result == DialogResult.negative) {
      return;
    }

    try {
      store.dispatch(SelectProject('-1'));
      await _leaveSharedProject(projectId, store);
      Navigator.of(context).popUntil((route) => route.isFirst == true);

      return;
    } catch (error) {
      throw error;
    }
  };
}

void _deleteSharedProject(
    String projectId, Store<AppState> store, BuildContext context) async {
  var members = store.state.members[projectId];
  if (members == null) {
    // Not a shared project.
    await _deleteProject(projectId, store);
    return;
  }

  if (_canDeleteSharedProject(store.state.user.userId, members) == false) {
    // User does not have sufficent permissions to Delete Project. Inform and bail out.
    await postAlertDialog(
        'Insufficent permissions',
        'Sorry, you do not have permission to delete this project, only Owners can delete projects shared with other contributors.',
        'Okay',
        context);
    return;
  }

  try {
    await _cloudFunctionsLayer.removeRemoteProject(projectId: projectId);
    store.dispatch(SelectProject('-1'));
    Navigator.of(context).popUntil((route) => route.isFirst);
  } catch (error) {
    throw error;
  }
}

bool _canDeleteSharedProject(String userId, List<MemberModel> members) {
  var selfMember =
      members.firstWhere((item) => item.userId == userId, orElse: () => null);

  if (selfMember == null) {
    return false;
  }

  return selfMember.role == MemberRole.owner;
}

Future<void> _leaveSharedProject(
    String projectId, Store<AppState> store) async {
  try {
    await _cloudFunctionsLayer.kickUserFromProject(
        projectId: projectId, userId: store.state.user.userId);
    return;
  } catch (error) {
    throw error;
  }
}

bool _isLastOwner(String userId, List<MemberModel> members) {
  var owners = members.where((item) => item.role == MemberRole.owner).toList();
  if (owners.length == 1 && owners[0].userId == userId) {
    // Current user is the Last Owner.
    return true;
  }

  return false;
}

ThunkAction<AppState> promoteUser(String userId, String projectId) {
  return (Store<AppState> store) async {
    try {
      store.dispatch(SetProcessingMembers(
          processingMembers: store.state.processingMembers..add(userId)));

      await _promoteUser(userId, projectId);

      store.dispatch(SetProcessingMembers(
          processingMembers: store.state.processingMembers..remove(userId)));
    } catch (error) {
      throw error;
    }
  };
}

Future<void> _promoteUser(String userId, String projectId) async {
  try {
    var memberRef = _getMembersCollectionRef(projectId).document(userId);
    await memberRef.updateData({
      'role': convertMemberRole(MemberRole.owner),
    });
    return;
  } catch (error) {
    throw error;
  }
}

ThunkAction<AppState> demoteUser(String userId, String projectId) {
  return (Store<AppState> store) async {
    var memberRef = _getMembersCollectionRef(projectId).document(userId);

    try {
      store.dispatch(SetProcessingMembers(
          processingMembers: store.state.processingMembers..add(userId)));
      await memberRef.updateData({
        'role': convertMemberRole(MemberRole.member),
      });
      store.dispatch(SetProcessingMembers(
          processingMembers: store.state.processingMembers..remove(userId)));
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> kickUserFromProject(String userId, String projectId,
    String displayName, String projectName, BuildContext context) {
  return (Store<AppState> store) async {
    var dialogResult = await postConfirmationDialog(
        'Kick user',
        'Are you sure you want to kick $displayName from $projectName?',
        'Kick',
        'Cancel',
        context);

    if (dialogResult == DialogResult.negative) {
      return;
    }

    try {
      store.dispatch(SetProcessingMembers(
          processingMembers: store.state.processingMembers..add(userId)));
      await _cloudFunctionsLayer.kickUserFromProject(
          userId: userId, projectId: projectId);
      store.dispatch(SetProcessingMembers(
          processingMembers: store.state.processingMembers..remove(userId)));
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> deleteProjectWithDialog(
    String projectId, String projectName, BuildContext context) {
  return (Store<AppState> store) async {
    if (store.state.members[projectId] != null &&
        store.state.members[projectId].length > 1) {
      var dialogResult = await postConfirmationDialog(
        'Delete Project',
        'Are you sure you want to delete $projectName? It will be permanently deleted for all contributors',
        'Delete',
        'Cancel',
        context,
      );

      if (dialogResult == DialogResult.negative) {
        return;
      }

      _deleteSharedProject(projectId, store, context);
    }

    var dialogResult = await postConfirmationDialog(
        "Delete Project",
        'Are you sure you want to delete $projectName?',
        'Delete',
        'Cancel',
        context);

    if (dialogResult == DialogResult.negative) {
      return;
    }

    await _deleteProject(projectId, store);
  };
}

Future<void> _deleteProject(String projectId, Store<AppState> store) async {
  var userId = store.state.user.userId;
  var allMemberIds =
      _getProjectRelatedMemberIds(projectId, store.state.members);
  var otherMemberIds = allMemberIds.where((id) => id != userId).toList();
  var taskIds = _getProjectRelatedTaskIds(projectId, store.state.tasks);
  var taskListIds =
      _getProjectRelatedTaskListIds(projectId, store.state.taskLists);
  var batch = Firestore.instance.batch();
  bool isOnlySharedWithSelf =
      allMemberIds.length == 1 && allMemberIds[0] == userId;

  if (isOnlySharedWithSelf) {
    // Project not shared with anyone else. It is safe to remove the user from the Members collection.
    batch.delete(_getMembersCollectionRef(projectId).document(userId));
  }

  // Build Tasks into Batch
  for (var id in taskIds) {
    batch.delete(_getTasksCollectionRef(projectId, store).document(id));
  }

  // Build TaskLists into Batch.
  for (var id in taskListIds) {
    batch.delete(_getTaskListsCollectionRef(projectId, store).document(id));
  }

  batch.delete(_getProjectsCollectionRef(store).document(projectId));
  batch.delete(_getProjectIdsCollectionRef(userId).document(projectId));

  try {
    if (!isOnlySharedWithSelf) {
      // Remove for other Users.
      var cloudFunctionRequests = otherMemberIds.map((id) =>
          _cloudFunctionsLayer.kickUserFromProject(
              userId: id, projectId: projectId));
      await Future.wait(cloudFunctionRequests);
    }
    await batch.commit();
    return;
  } catch (error) {
    throw error;
  }
}

List<String> _getProjectRelatedMemberIds(
    String projectId, Map<String, List<MemberModel>> members) {
  var memberList = members[projectId];

  if (memberList == null) {
    return <String>[];
  }

  return memberList.map((item) => item.userId);
}

ThunkAction<AppState> showSignUpDialog(BuildContext context) {
  return (Store<AppState> store) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SignUpBase(
            firebaseAuth: auth,
            firestore: Firestore.instance,
          );
        });
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
    var userId = store.state.user.userId;

    if (result is TextInputDialogResult &&
        result.result == DialogResult.affirmative) {
      var batch = Firestore.instance.batch();

      // Project Entity Ref.
      var projectRef = _getProjectsCollectionRef(store).document();
      var project = ProjectModel(
        uid: projectRef.documentID,
        projectName: result.value,
        created: DateTime.now().toIso8601String(),
      );

      // Project ID Ref.
      var projectIdRef =
          _getProjectIdsCollectionRef(userId).document(projectRef.documentID);
      var projectId = ProjectIdModel(
        uid: projectRef.documentID,
      );

      // Member Ref.
      var memberRef = _getProjectMembersCollectionRef(projectRef.documentID)
          .document(userId);
      var member =
          store.state.user.toMember(MemberRole.owner, MemberStatus.added);

      batch.setData(projectRef, project.toMap());
      batch.setData(projectIdRef, projectId.toMap());
      batch.setData(memberRef, member.toMap());

      try {
        await batch.commit();
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
    var preselectedTaskList = _getAddTaskDialogPreselectedTaskList(
        projectId, taskListId, store.state);

    var result = await postAddTaskDialog(
      context,
      preselectedTaskList,
      taskLists: store.state.filteredTaskLists,
      allowTaskListChange: taskListId ==
          null, // No taskListId provided. So allow the user to choose one.
    );

    if (result == null) {
      return;
    }

    if (result is AddTaskDialogResult &&
        result.result == DialogResult.affirmative) {
      if (result.isNewTaskList == true) {
        // User has elected to create a new TaskList
        var batch = Firestore.instance.batch();

        // New TaskList
        var taskListRef =
            _getTaskListsCollectionRef(projectId, store).document();

        var newTaskList = TaskListModel(
          uid: taskListRef.documentID,
          project: projectId,
          taskListName: result.taskListName,
        );

        // New Task
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

        // Push the new value to lastUsedTaskLists
        store.dispatch(PushLastUsedTaskList(
          projectId: projectId,
          taskListId: newTaskList.uid,
        ));

        try {
          await batch.commit();
        } catch (error) {
          throw error;
        }
      } else {
        // User selected an existing TaskList.
        var taskRef = _getTasksCollectionRef(projectId, store).document();
        var targetTaskListId = result.taskListId ??
            taskListId; // Use the taskListId parameter if Dialog returns a null taskListId.

        var task = TaskModel(
          uid: taskRef.documentID,
          taskList: targetTaskListId,
          project: projectId,
          taskName: result.taskName,
          dueDate: result.selectedDueDate,
          isHighPriority: result.isHighPriority,
          dateAdded: DateTime.now(),
        );

        // Push the new value to lastUsedTaskLists
        store.dispatch(PushLastUsedTaskList(
          projectId: projectId,
          taskListId: targetTaskListId,
        ));

        try {
          await taskRef.setData(task.toMap());
        } catch (error) {
          throw error;
        }
      }
    }
  };
}

TaskListModel _getAddTaskDialogPreselectedTaskList(
    String projectId, String taskListId, AppState state) {
  // Try to retreive a Tasklist to become the Preselected List for the AddTaskDialog.
  // Honor these rules in order.
  // 1. Try and retrieve Tasklist directly using provided taskListId (if provided). This indicates the user has
  //  used the TaskList addTask button instead of the Fab.
  // 2. Try and retreive using the Users elected Faviroute Task List: TODO: Implement This.
  // 3. Try and retreive using the lastUsedTaskLists Map. (Most recent addition).

  // First try and retrieve directly.
  if (taskListId != null && taskListId != '-1') {
    var extractedTaskList = state.filteredTaskLists
        .firstWhere((item) => item.uid == taskListId, orElse: () => null);
    if (extractedTaskList != null) {
      return extractedTaskList;
    }
  }

  // Retreiving directly failed, probably because no taskListId was provided to begin with.
  // So now try and retrieve from lastUsedTaskLists.
  var lastUsedTaskListId = state.lastUsedTaskLists[projectId];
  if (lastUsedTaskListId != null) {
    var extractedTaskList = state.filteredTaskLists.firstWhere(
        (item) => item.uid == lastUsedTaskListId,
        orElse: () => null);

    if (extractedTaskList != null) {
      return extractedTaskList;
    }
  }

  // Everything has Failed. TaskList could not be retrieved.
  return null;
}

ThunkAction<AppState> updateTaskComplete(String taskId, bool newValue) {
  return (Store<AppState> store) async {
    var userId = store.state.user.userId;

    await _getTasksCollectionRef(store.state.selectedProjectId, store)
        .document(taskId)
        .updateData({'isComplete': newValue});
  };
}

StreamSubscription<QuerySnapshot> _subscribeToTaskLists(
    String projectId, Store<AppState> store) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('taskLists')
      .snapshots()
      .listen(
          (snapshot) => _handleTaskListsSnapshot(snapshot, projectId, store));
}

void _handleTaskListsSnapshot(
    QuerySnapshot snapshot, String originProjectId, Store<AppState> store) {
  var taskLists = <TaskListModel>[];
  var checklists = <TaskListModel>[];

  snapshot.documents.forEach((doc) {
    var taskList = TaskListModel.fromDoc(doc);
    taskLists.add(taskList);

    if (taskList.settings?.checklistSettings?.isChecklist == true) {
      checklists.add(taskList);
    }
  });

  store.dispatch(
      ReceiveTaskLists(taskLists: taskLists, originProjectId: originProjectId));
  store.dispatch(processChecklists(checklists));
}

ThunkAction<AppState> subscribeToLocalTaskLists(String userId) {
  return (Store<AppState> store) async {};
}

ThunkAction<AppState> processChecklists(List<TaskListModel> checklists) {
  return (Store<AppState> store) async {
    for (var taskList in checklists) {
      renewChecklist(taskList, store);
    }
  };
}

void renewChecklist(TaskListModel checklist, Store<AppState> store,
    {bool isManuallyInitiated = false}) async {
  if (checklist.settings.checklistSettings.isDueForRenew == false &&
      isManuallyInitiated == false) {
    return;
  }

  print('Renewing ${checklist.taskListName}');

  // 'unComplete' related Tasks.
  var batch = Firestore.instance.batch();
  var snapshot = await _getTasksCollectionRef(checklist.project, store)
      .where('taskList', isEqualTo: checklist.uid)
      .getDocuments();

  snapshot.documents
      .forEach((doc) => batch.updateData(doc.reference, {'isComplete': false}));

  try {
    batch.commit();
  } catch (error) {
    throw error;
  }

  // Update TaskList.
  if (isManuallyInitiated == false) {
    var currentChecklistSettings = checklist.settings.checklistSettings;
    var newSettings = checklist.settings.copyWith(
        checklistSettings: currentChecklistSettings.copyWith(
            lastRenewDate: determineNextRenewDate(
                currentChecklistSettings.lastRenewDate ??
                    currentChecklistSettings.initialStartDate,
                currentChecklistSettings.renewInterval)));

    var ref = _getTaskListsCollectionRef(checklist.project, store)
        .document(checklist.uid);

    try {
      ref.updateData({'settings': newSettings.toMap()});
    } catch (error) {
      throw error;
    }
  }
}

DateTime determineNextRenewDate(DateTime lastRenewDate, int renewInterval) {
  assert(lastRenewDate != null);

  var now = normalizeDate(DateTime.now());
  var projectedRenewDate = lastRenewDate.add(Duration(days: renewInterval));
  if (projectedRenewDate.isAfter(now)) {
    return projectedRenewDate;
  }

  // The next projectedRenewDate is still behind Today's Date. We have to play catchup. In other words, wind the date forward
  // honoring the renewInterval until we find a date in the Future.
  while (now.isAfter(projectedRenewDate)) {
    projectedRenewDate = projectedRenewDate.add(Duration(days: renewInterval));
  }

  return projectedRenewDate;
}

StreamSubscription<QuerySnapshot> _subscribeToIncompletedTasks(
    String projectId, Store<AppState> store) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('tasks')
      .where('isComplete', isEqualTo: false)
      .snapshots()
      .listen((snapshot) => _handleTasksSnapshot(snapshot, projectId, store));
}

void _handleTasksSnapshot(
    QuerySnapshot snapshot, String originProjectId, Store<AppState> store) {
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

  store.dispatch(ReceiveTasks(tasks: tasks, originProjectId: originProjectId));

  _driveTaskAdditionAnimations(
      store.state.inflatedProject, groupedDocumentChanges.added);
}

StreamSubscription<QuerySnapshot> _subscribeToProjectIds(
    String userId, Store<AppState> store) {
  return _getProjectIdsCollectionRef(userId).snapshots().listen((data) {
    for (var change in data.documentChanges) {
      var projectId = change.document.documentID;
      // Added.
      if (change.type == DocumentChangeType.added) {
        _firestoreStreams.projectSubscriptions[projectId] =
            ProjectSubscriptionContainer(
                uid: projectId,
                project: _subscribeToProject(projectId, store),
                members: _subscribeToMembers(projectId, store),
                taskLists: _subscribeToTaskLists(projectId, store),
                incompletedTasks:
                    _subscribeToIncompletedTasks(projectId, store));
      }

      if (change.type == DocumentChangeType.removed) {
        // Deleted.
        _firestoreStreams.projectSubscriptions[projectId]?.cancelAll();
        store.dispatch(RemoveProjectEntities(projectId: projectId));
      }
    }
  });
}

StreamSubscription<QuerySnapshot> _subscribeToMembers(
    String projectId, Store<AppState> store) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('members')
      .snapshots()
      .listen((snapshot) {
    List<MemberModel> members = [];
    snapshot.documents.forEach((doc) => members.add(MemberModel.fromDoc(doc)));

    store.dispatch(ReceiveMembers(projectId: projectId, membersList: members));
  });
}

StreamSubscription<DocumentSnapshot> _subscribeToProject(
    String projectId, Store<AppState> store) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .snapshots()
      .listen((doc) {
    if (doc.exists) {
      store.dispatch(ReceiveProject(project: ProjectModel.fromDoc(doc)));
    }
  });
}

ThunkAction<AppState> openChecklistSettings(
    TaskListModel taskList, BuildContext context) {
  return (Store<AppState> store) async {
    var currentSettings = taskList.settings.checklistSettings;

    var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ChecklistSettingsDialog(
            renewDate: currentSettings.nextRenewDate ??
                currentSettings.initialStartDate,
            isChecklist: currentSettings.isChecklist,
            renewInterval: currentSettings.renewInterval,
          ),
    );

    if (result != null && result is ChecklistSettingsDialogResult) {
      if (result.renewNow == true) {
        // Renew Now
        renewChecklist(taskList, store, isManuallyInitiated: true);

        return;
      } else {
        var ref = _getTaskListsCollectionRef(taskList.project, store)
            .document(taskList.uid);
        var newTaskListSettings = taskList.settings.copyWith(
            checklistSettings: ChecklistSettingsModel(
          isChecklist: result.isChecklist,
          initialStartDate: result.renewDate,
          lastRenewDate:
              null, // If we got here, the user changed a setting, therefore reset lastRenewDate so checklist will be
          // auto renewed as we would expect.
          renewInterval: result.renewInterval,
        ));

        try {
          await ref.updateData({'settings': newTaskListSettings.toMap()});
        } catch (error) {
          throw error;
        }
      }
    }
  };
}

CollectionReference _getInvitesCollectionRef(
  String userId,
) {
  return Firestore.instance
      .collection('users')
      .document(userId)
      .collection('invites');
}

CollectionReference _getMembersCollectionRef(
  String projectId,
) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('members');
}

CollectionReference _getTasksCollectionRef(
    String projectId, Store<AppState> store) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('tasks');
}

CollectionReference _getTaskListsCollectionRef(
    String projectId, Store<AppState> store) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('taskLists');
}

CollectionReference _getProjectMembersCollectionRef(String projectId) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('members');
}

CollectionReference _getProjectIdsCollectionRef(String userId) {
  return Firestore.instance
      .collection('users')
      .document(userId)
      .collection('projectIds');
}

CollectionReference _getProjectsCollectionRef(Store<AppState> store) {
  return Firestore.instance.collection('projects');
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
