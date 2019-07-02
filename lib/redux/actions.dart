import 'dart:async';
import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handball_flutter/FirestoreStreamsContainer.dart';
import 'package:handball_flutter/configValues.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/models/AccountConfig.dart';
import 'package:handball_flutter/models/AppTheme.dart';
import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/models/ChecklistSettings.dart';
import 'package:handball_flutter/models/Comment.dart';
import 'package:handball_flutter/models/DirectoryListing.dart';
import 'package:handball_flutter/models/GroupedDocumentChanges.dart';
import 'package:handball_flutter/models/InflatedProject.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/ProjectIdModel.dart';
import 'package:handball_flutter/models/ProjectInvite.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/ServerCleanupJobs/CleanupTaskListMove.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/TaskListSettings.dart';
import 'package:handball_flutter/models/TaskMetadata.dart';
import 'package:handball_flutter/models/TextInputDialogModel.dart';
import 'package:handball_flutter/models/UndoActions/DeleteTaskUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/NoAction.dart';
import 'package:handball_flutter/models/UndoActions/UndoAction.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:handball_flutter/presentation/Dialogs/AddTaskDialog/AddTaskDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/ChecklistSettingsDialog/ChecklistSettingsDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/DelegateOwnerDialog/DelegateOwnerDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/MoveListBottomSheet.dart';
import 'package:handball_flutter/presentation/Dialogs/MoveTasksDialog/MoveTaskBottomSheet.dart';
import 'package:handball_flutter/presentation/Dialogs/TextInputDialog.dart';
import 'package:handball_flutter/presentation/Screens/ListSortingScreen/ListSortingScreen.dart';
import 'package:handball_flutter/presentation/Screens/SignUp/SignUpBase.dart';
import 'package:handball_flutter/presentation/Task/Task.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/utilities/TaskAnimationUpdate.dart';
import 'package:handball_flutter/utilities/TaskArgumentParser/TaskArgumentParser.dart';
import 'package:handball_flutter/utilities/UndoRedo/parseUndoAction.dart';
import 'package:handball_flutter/utilities/UndoRedo/pushUndoAction.dart';
import 'package:handball_flutter/utilities/UndoRedo/undoActionSharedPreferencesKey.dart';
import 'package:handball_flutter/utilities/UndoRedo/undoLastAction.dart';
import 'package:handball_flutter/utilities/buildInflatedProject.dart';
import 'package:handball_flutter/utilities/convertMemberRole.dart';
import 'package:handball_flutter/utilities/extractListCustomSortOrder.dart';
import 'package:handball_flutter/utilities/extractProject.dart';
import 'package:handball_flutter/utilities/listSortingHelpers.dart';
import 'package:handball_flutter/utilities/normalizeDate.dart';
import 'package:handball_flutter/utilities/truncateString.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:handball_flutter/utilities/CloudFunctionLayer.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirestoreStreamsContainer _firestoreStreams = FirestoreStreamsContainer();
final CloudFunctionsLayer _cloudFunctionsLayer = CloudFunctionsLayer();

class OpenAppSettings {
  final AppSettingsTabs tab;

  OpenAppSettings({
    this.tab,
  });
}

class ReceiveAccountConfig {
  final AccountConfigModel accountConfig;

  ReceiveAccountConfig({
    this.accountConfig,
  });
}

class ReceiveTaskComments {
  final List<CommentModel> taskComments;

  ReceiveTaskComments({this.taskComments});
}

class AddMultiSelectedTask {
  final TaskModel task;

  AddMultiSelectedTask({this.task});
}

class RemoveMultiSelectedTask {
  final TaskModel task;
  RemoveMultiSelectedTask({this.task});
}

class SetIsInMultiSelectTaskMode {
  final bool isInMultiSelectTaskMode;
  final TaskModel initialSelection;

  SetIsInMultiSelectTaskMode({
    this.isInMultiSelectTaskMode,
    this.initialSelection,
  });
}

class SetIsGettingTaskComments {
  final bool isGettingTaskComments;

  SetIsGettingTaskComments({this.isGettingTaskComments});
}

class SetIsPaginatingTaskComments {
  final bool isPaginatingTaskComments;

  SetIsPaginatingTaskComments({this.isPaginatingTaskComments});
}

class CloseAppSettings {}

class SetProcessingProjectInviteIds {
  final List<String> processingProjectInviteIds;

  SetProcessingProjectInviteIds({
    this.processingProjectInviteIds,
  });
}

class SetIsTaskCommentPaginationComplete {
  final bool isComplete;

  SetIsTaskCommentPaginationComplete({this.isComplete});
}

class SetListSorting {
  final TaskListSorting listSorting;

  SetListSorting({this.listSorting});
}

class SetProcessingMembers {
  final List<String> processingMembers;

  SetProcessingMembers({
    this.processingMembers,
  });
}

class SetShowOnlySelfTasks {
  final bool showOnlySelfTasks;

  SetShowOnlySelfTasks({this.showOnlySelfTasks});
}

class SetInflatedProject {
  final InflatedProjectModel inflatedProject;

  SetInflatedProject({this.inflatedProject});
}

class SetIsInvitingUser {
  final bool isInvitingUser;

  SetIsInvitingUser({
    this.isInvitingUser,
  });
}

class SetShowCompletedTasks {
  final bool showCompletedTasks;

  SetShowCompletedTasks({
    this.showCompletedTasks,
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

class ReceiveIncompletedTasks {
  final List<TaskModel> tasks;
  final String originProjectId;

  ReceiveIncompletedTasks(
      {@required this.tasks, @required this.originProjectId});
}

class ReceiveCompletedTasks {
  final List<TaskModel> tasks;
  final String originProjectId;

  ReceiveCompletedTasks({
    @required this.tasks,
    @required this.originProjectId,
  });
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

class OpenTaskCommentsScreen {}

class CloseTaskCommentsScreen {}

class CloseTaskInspector {}

class SetTextInputDialog {
  final TextInputDialogModel dialog;

  SetTextInputDialog({this.dialog});
}

class SetLastUndoAction {
  final UndoActionModel lastUndoAction;

  SetLastUndoAction({
    this.lastUndoAction,
  });
}

Future<TextInputDialogResult> postTextInputDialog(
    String title, String text, BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => TextInputDialog(title: title, text: text),
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

ThunkAction<AppState> updateProjectName(
    String existingName, String projectId, BuildContext context) {
  return (Store<AppState> store) async {
    if (projectId == null || projectId == '-1') {
      return;
    }

    var result =
        await postTextInputDialog('Rename Project', existingName, context);

    if (result is TextInputDialogResult &&
        result.result != DialogResult.negative) {
      var newName = result.value;
      if (newName.trim() == existingName) {
        return;
      }

      var ref = _getProjectsCollectionRef(store).document(projectId);

      try {
        await ref.updateData({'projectName': newName.trim()});
      } catch (error) {
        throw error;
      }
    }
  };
}

ThunkAction<AppState> initializeApp() {
  return (Store<AppState> store) async {
    homeScreenScaffoldKey?.currentState?.openDrawer();

    store.onChange.listen((state) => print(state.lastUndoAction));

    // Firestore settings.
    // TODO: Is this even doing anything?
    Firestore.instance.settings(timestampsInSnapshotsEnabled: true);

    // Auth Listener
    auth.onAuthStateChanged.listen((user) => onAuthStateChanged(store, user));

    // Pull listSorting and lastUndoAction from SharedPreferences.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    TaskListSorting listSorting =
        parseTaskListSorting(prefs.getString('listSorting'));
    store.dispatch(SetListSorting(listSorting: listSorting));

    var lastUndoAction =
        parseUndoAction(prefs.getString(undoActionSharedPreferencesKey));
    store.dispatch(SetLastUndoAction(lastUndoAction: lastUndoAction ?? NoAction()));
  };
}

void onAuthStateChanged(Store<AppState> store, FirebaseUser user) async {
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
  _firestoreStreams.accountConfig = _subscribeToAccountConfig(userId, store);
  _firestoreStreams.invites = _subscribeToProjectInvites(userId, store);
  _firestoreStreams.projectIds = _subscribeToProjectIds(userId, store);
}

StreamSubscription<DocumentSnapshot> _subscribeToAccountConfig(
    String userId, Store<AppState> store) {
  return _getAccountConfigDocumentReference(userId)
      .snapshots()
      .listen((docSnapshot) {
    if (docSnapshot.exists) {
      var accountConfig = AccountConfigModel.fromDoc(docSnapshot);
      store.dispatch(ReceiveAccountConfig(accountConfig: accountConfig));
    }
  });
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

ThunkAction<AppState> updateAppTheme(AppThemeModel newAppTheme) {
  return (Store<AppState> store) async {
    if (newAppTheme == null || store.state.user.isLoggedIn == false) {
      return;
    }

    newAppTheme.debugPrint();

    if (store.state.accountConfig == null) {
      // Account Config doesn't exist yet.
      var accountConfigRef =
          _getAccountConfigDocumentReference(store.state.user.userId);
      var newAccountConfig = AccountConfigModel(appTheme: newAppTheme);
      await accountConfigRef.setData(newAccountConfig.toMap());
    } else {
      // Account Config already Exists.
      var ref = _getAccountConfigDocumentReference(store.state.user.userId);
      await ref.updateData({'appTheme': newAppTheme.toMap()});
    }
  };
}

DocumentReference _getAccountConfigDocumentReference(String userId) {
  return Firestore.instance
      .collection('users')
      .document(userId)
      .collection('accountConfig')
      .document('0');
}

void removeProccessingProjectInviteId(String projectId, Store<AppState> store) {
  List<String> newList = store.state.processingProjectInviteIds
      .where((item) => item != projectId)
      .toList();

  store.dispatch(
      SetProcessingProjectInviteIds(processingProjectInviteIds: newList));
}

ThunkAction<AppState> setShowOnlySelfTasks(bool showOnlySelfTasks) {
  return (Store<AppState> store) async {
    var projectId = store.state.selectedProjectId;

    var inflatedProject = buildInflatedProject(
      tasks: store.state.tasksByProject[projectId],
      taskLists: store.state.taskListsByProject[projectId],
      listCustomSortOrder: extractListCustomSortOrder(
          store.state.members, projectId, store.state.user.userId),
      listSorting: store.state.listSorting,
      project: extractProject(projectId, store.state.projects),
      showOnlySelfTasks: showOnlySelfTasks,
    );

    var preMutationTaskIndices =
        Map<String, int>.from(store.state.inflatedProject.taskIndices);
    var postMutationTaskIndices =
        Map<String, int>.from(inflatedProject.taskIndices);

    var hiddenTasks = store.state.tasksByProject[projectId]
        .where((task) => task.isAssignedToSelf == false)
        .toList();

    for (var task in hiddenTasks) {
      print(task.taskName);
    }

    store.dispatch(SetInflatedProject(inflatedProject: inflatedProject));
    store.dispatch(SetShowOnlySelfTasks(showOnlySelfTasks: showOnlySelfTasks));

    if (showOnlySelfTasks == true) {
      var removalAnimationUpdates = hiddenTasks.map((task) {
        return TaskAnimationUpdate(
            index: _getTaskAnimationIndex(preMutationTaskIndices, task.uid),
            listStateKey: _getAnimatedListStateKey(task.taskList),
            task: task);
      }).toList();

      removalAnimationUpdates.sort(TaskAnimationUpdate.removalSorter);

      _driveTaskRemovalAnimations(removalAnimationUpdates);
    } else {
      var additionAnimationUpdates = hiddenTasks.map((task) {
        return TaskAnimationUpdate(
          index: _getTaskAnimationIndex(postMutationTaskIndices, task.uid),
          listStateKey: _getAnimatedListStateKey(task.taskList),
          task: null,
        );
      }).toList();

      additionAnimationUpdates.sort(TaskAnimationUpdate.additionSorter);
      _driveTaskAdditionAnimations(additionAnimationUpdates);
    }
  };
}

ThunkAction<AppState> moveTasksToListWithDialog(
    List<TaskModel> tasks,
    String projectId,
    List<TaskListModel> sortedTaskLists,
    BuildContext context) {
  return (Store<AppState> store) async {
    store.dispatch(SetIsInMultiSelectTaskMode(isInMultiSelectTaskMode: false));
    if (tasks == null || tasks.length == 0 || sortedTaskLists == null) {
      return;
    }

    // If the user is only moving one task. Filter out the taskList that already contains that task. Otherwise, provide all
    // options.
    var taskListOptions = tasks.length == 1
        ? sortedTaskLists
            .where((item) => item.uid != tasks.first.taskList)
            .toList()
        : sortedTaskLists;

    var moveTasksResult = await showModalBottomSheet(
        context: context,
        builder: (context) => MoveTasksBottomSheet(
              taskListOptions: taskListOptions,
            ));

    if (moveTasksResult == null) {
      return;
    }

    if (moveTasksResult is MoveTaskBottomSheetResult) {
      String destinationTaskListId;
      var batch = Firestore.instance.batch();

      if (moveTasksResult.isNewTaskList == true) {
        // Create a new TaskList before proceeding.
        var ref = _getTaskListsCollectionRef(projectId).document();
        var taskList = TaskListModel(
          dateAdded: DateTime.now(),
          project: projectId,
          uid: ref.documentID,
          taskListName: moveTasksResult.taskListName,
        );

        destinationTaskListId = taskList.uid;
        batch.setData(ref, taskList.toMap());
      } else {
        destinationTaskListId = moveTasksResult.taskListId;
      }

      var actuallyMovingTasks = tasks
          .where((item) => item.taskList != destinationTaskListId)
          .toList();

      try {
        moveTasks(actuallyMovingTasks, destinationTaskListId, projectId, batch,
            store.state.user.displayName);
      } catch (error) {
        throw error;
      }
    }
  };
}

Future<void> moveTasks(List<TaskModel> tasks, String destinationTaskListId,
    String projectId, WriteBatch batch, String displayName) {
  for (var task in tasks) {
    var ref = _getTasksCollectionRef(projectId).document(task.uid);
    batch.updateData(ref, {'taskList': destinationTaskListId});
    batch.updateData(ref, {
      'metadata': _getUpdatedTaskMetadata(
              task.metadata, TaskMetadataUpdateType.updated, displayName)
          .toMap(),
    });
  }

  return batch.commit();
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

showSnackBar(
    {@required GlobalKey<ScaffoldState> targetGlobalKey,
    @required String message,
    int autoHideSeconds = 6,
    String actionLabel,
    dynamic onClosed}) async {
  if (targetGlobalKey?.currentState == null) {
    throw ArgumentError(
        'targetGlobalKey or targetGlobalKey.currentState must not be null');
  }

  var duration =
      autoHideSeconds == 0 ? null : Duration(seconds: autoHideSeconds);
  var snackBarAction = actionLabel == null
      ? null
      : SnackBarAction(
          label: actionLabel,
          onPressed: () => targetGlobalKey.currentState
              .hideCurrentSnackBar(reason: SnackBarClosedReason.action),
        );

  var featureController = targetGlobalKey.currentState.showSnackBar(SnackBar(
    content: Text(message ?? ''),
    action: snackBarAction,
    duration: duration,
  ));

  if (onClosed != null) {
    var reason = await featureController.closed;
    onClosed(reason);
  }
}

ThunkAction<AppState> inviteUserToProject(
    String email, String sourceProjectId, String projectName, MemberRole role) {
  return (Store<AppState> store) async {
    if (email == store.state.user.email) {
      showSnackBar(
          targetGlobalKey: shareScreenScaffoldKey,
          message:
              'Hey! You are already a contributor! No need to invite yourself.');
      return;
    }

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

      showSnackBar(
          targetGlobalKey: shareScreenScaffoldKey,
          message: 'Invite sent to ${response.displayName}.');
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

ThunkAction<AppState> changeAccount(
    String email, String password, BuildContext context) {
  return (Store<AppState> store) async {
    try {
      await auth.signOut();
      await Future.delayed(Duration(seconds: 2));
      store.dispatch(signInUser(email, password, context));
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> updateTaskPriority(bool newValue, String taskId,
    String projectId, TaskMetadata existingMetadata) {
  return (Store<AppState> store) async {
    var ref = _getTasksCollectionRef(projectId).document(taskId);

    try {
      await ref.updateData({'isHighPriority': newValue});
      await ref.updateData({
        'metadata': _getUpdatedTaskMetadata(existingMetadata,
                TaskMetadataUpdateType.updated, store.state.user.displayName)
            .toMap()
      });
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> updateTaskNote(String newValue, String oldValue,
    String taskId, String projectId, TaskMetadata existingMetadata) {
  return (Store<AppState> store) async {
    if (newValue?.trim() == oldValue?.trim()) {
      return;
    }

    var ref = _getTasksCollectionRef(projectId).document(taskId);
    var coercedValue = newValue ?? '';

    try {
      await ref.updateData({'note': coercedValue});
      await ref.updateData({
        'metadata': _getUpdatedTaskMetadata(existingMetadata,
                TaskMetadataUpdateType.updated, store.state.user.displayName)
            .toMap()
      });
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> updateTaskAssignments(
    List<String> newAssignments,
    List<String> oldAssignments,
    String taskId,
    String projectId,
    TaskMetadata existingMetadata) {
  return (Store<AppState> store) async {
    var batch = Firestore.instance.batch();
    var ref = _getTasksCollectionRef(projectId).document(taskId);

    batch.updateData(ref, {'assignedTo': newAssignments});
    batch.updateData(ref, {
      'metadata': _getUpdatedTaskMetadata(existingMetadata,
              TaskMetadataUpdateType.updated, store.state.user.userId)
          .toMap()
    });

    try {
      await batch.commit();
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> updateTaskDueDate(String taskId, DateTime newValue,
    DateTime oldValue, TaskMetadata existingMetadata) {
  return (Store<AppState> store) async {
    if (newValue == oldValue) {
      return;
    }

    var ref =
        _getTasksCollectionRef(store.state.selectedProjectId).document(taskId);
    String coercedValue = newValue == null ? '' : newValue.toIso8601String();

    try {
      await ref.updateData({'dueDate': coercedValue});
      await ref.updateData({
        'metadata': _getUpdatedTaskMetadata(existingMetadata,
                TaskMetadataUpdateType.updated, store.state.user.displayName)
            .toMap(),
      });
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
  var owners = members
      .where((item) =>
          item.role == MemberRole.owner && item.status != MemberStatus.denied)
      .toList();
  if (owners.length == 1 && owners[0].userId == userId) {
    // Current user is the Last Owner.
    return true;
  }

  return false;
}

ThunkAction<AppState> getTaskComments(String projectId, String taskId) {
  return (Store<AppState> store) async {
    store.dispatch(SetIsGettingTaskComments(isGettingTaskComments: true));

    var snapshot = await Firestore.instance
        .collection('projects')
        .document(projectId)
        .collection('tasks')
        .document(taskId)
        .collection('taskComments')
        .orderBy('timestamp', descending: true)
        .limit(taskCommentQueryLimit + 1)
        .getDocuments();

    store.dispatch(SetIsGettingTaskComments(isGettingTaskComments: false));
    _handleTaskCommentsSnapshot(store, snapshot);
  };
}

ThunkAction<AppState> openTaskCommentsScreen(String projectId, String taskId) {
  return (Store<AppState> store) async {
    if (projectId == null || taskId == null) {
      return;
    }

    store.dispatch(getTaskComments(projectId, taskId));
    store.dispatch(OpenTaskCommentsScreen());
  };
}

ThunkAction<AppState> closeTaskCommentsScreen(String projectId, String taskId) {
  return (Store<AppState> store) async {
    store.dispatch(CloseTaskCommentsScreen());
    var selectedTaskEntity = store.state.selectedTaskEntity;

    if (projectId == null || taskId == null || selectedTaskEntity == null) {
      return;
    }

    var taskComments = store.state.taskComments.toList();
    var userId = store.state.user.userId;
    var taskRef = _getTasksCollectionRef(projectId).document(taskId);
    var batch = Firestore.instance.batch();

    // Posting and Deleting Comments already re-generates the Comment Preview. We only need to do so here, if we have
    // unread flags that need updating.
    var previewComments = _generateTaskCommentPreview(taskComments);
    if (_doesTaskCommentPreviewSeenByNeedUpdate(previewComments, userId)) {
      batch.updateData(taskRef, {
        'commentPreview': _seeComments(previewComments, userId)
            .map((item) => item.toMap())
            .toList()
      });
    }

    var commentsNeedingSeenByUpdate = taskComments
        .where((comment) => comment.seenBy.contains(userId) == false);

    for (var comment in commentsNeedingSeenByUpdate) {
      var commentRef =
          _getTaskCommentCollectionRef(projectId, taskId).document(comment.uid);
      var seenBy = comment.seenBy.toList();
      seenBy.add(userId);
      batch.updateData(commentRef, {'seenBy': seenBy});
    }

    if (commentsNeedingSeenByUpdate.length > 0) {
      // User viewed previously unread Comments. Update the Task level indicator.
      var currentUnseenTaskCommentMembers =
          Map<String, String>.from(selectedTaskEntity.unseenTaskCommentMembers);
      currentUnseenTaskCommentMembers.remove(userId);

      batch.updateData(taskRef,
          {'unseenTaskCommentMembers': currentUnseenTaskCommentMembers});
    }

    store.dispatch(ReceiveTaskComments(taskComments: <CommentModel>[]));
    store
        .dispatch(SetIsPaginatingTaskComments(isPaginatingTaskComments: false));
    store.dispatch(SetIsTaskCommentPaginationComplete(isComplete: false));
    store.dispatch(SetIsGettingTaskComments(isGettingTaskComments: false));

    try {
      await batch.commit();
    } catch (error) {
      throw error;
    }
  };
}

List<CommentModel> _seeComments(
    List<CommentModel> previewComments, String userId) {
  return previewComments.map((item) => item..seenBy.add(userId)).toList();
}

bool _doesTaskCommentPreviewSeenByNeedUpdate(
    List<CommentModel> previewComments, String userId) {
  return previewComments
          .where((item) => item.seenBy.contains(userId) == false)
          .length >
      0;
}

void _handleTaskCommentsSnapshot(
    Store<AppState> store, QuerySnapshot snapshot) {
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

ThunkAction<AppState> paginateTaskComments(String projectId, String taskId) {
  return (Store<AppState> store) async {
    if (store.state.taskComments.length == 0) {
      return;
    }

    store.dispatch(SetIsPaginatingTaskComments(isPaginatingTaskComments: true));

    var lastCommentDoc = store.state.taskComments.last.docSnapshot;
    print(store.state.taskComments.last.text);

    var snapshot = await Firestore.instance
        .collection('projects')
        .document(projectId)
        .collection('tasks')
        .document(taskId)
        .collection('taskComments')
        .orderBy('timestamp', descending: true)
        .startAfterDocument(lastCommentDoc)
        .limit(taskCommentQueryLimit + 1)
        .getDocuments();

    store
        .dispatch(SetIsPaginatingTaskComments(isPaginatingTaskComments: false));
    _handleTaskCommentsSnapshot(store, snapshot);
  };
}

ThunkAction<AppState> postTaskComment(
    TaskModel selectedTaskEntity, String text) {
  return (Store<AppState> store) async {
    if (selectedTaskEntity == null) {
      return;
    }

    var projectId = selectedTaskEntity.project;
    var userId = store.state.user.userId;
    var taskId = selectedTaskEntity.uid;
    var members = store.state.members[projectId];

    var batch = Firestore.instance.batch();
    var taskRef = _getTasksCollectionRef(projectId).document(taskId);
    var commentRef = _getTaskCommentCollectionRef(projectId, taskId).document();

    var comment = CommentModel(
        uid: commentRef.documentID,
        created: DateTime.now(),
        timestamp: DateTime.now(),
        createdBy: userId,
        displayName: store.state.user.displayName,
        seenBy: <String>[userId],
        text: text,
        isSynced: false);

    batch.setData(commentRef, comment.toMap());

    // Comment Preview
    var commentPreview = _generateTaskCommentPreview(store.state.taskComments,
        addedComment: comment);

    batch.updateData(taskRef, {
      'commentPreview':
          commentPreview.map((comment) => comment.toMap()).toList()
    });

    batch.updateData(taskRef, {
      'unseenTaskCommentMembers':
          _buildUnseenTaskCommentMembers(members, userId)
    });

    // Update State directly. We only use single Fire queries to get Task Comments so we aren't subscribed to Changes,
    // therefore we have to update State directly.
    store.dispatch(ReceiveTaskComments(
        taskComments: store.state.taskComments.toList()..insert(0, comment)));

    try {
      await batch.commit();

      // Update Sync Status of Comment within State.
      // We do this because we aren't subscribed to TaskComment changes, therefore Firestore won't
      // update the state for us.
      var unsyncedComment = store.state.taskComments
          .firstWhere((item) => item.uid == comment.uid, orElse: () => null);
      if (unsyncedComment != null) {
        unsyncedComment.isSynced = true;
        store.dispatch(ReceiveTaskComments(
            taskComments: store.state.taskComments.toList()));

        var updatedCommentPreview =
            commentPreview.map((item) => item..isSynced = true).toList();
        var newSelectedTaskEntity = store.state.selectedTaskEntity
            .copyWith(commentPreview: updatedCommentPreview);
        store
            .dispatch(SetSelectedTaskEntity(taskEntity: newSelectedTaskEntity));
      }
    } catch (error) {
      throw (error);
    }
  };
}

ThunkAction<AppState> deleteTaskComment(
    TaskModel selectedTaskEntity, CommentModel comment) {
  return (Store<AppState> store) async {
    if (selectedTaskEntity == null || comment == null) {
      return;
    }

    var taskId = selectedTaskEntity.uid;
    var projectId = selectedTaskEntity.project;
    var commentId = comment.uid;

    var newTaskComments = store.state.taskComments.toList()
      ..removeWhere((item) => item.uid == commentId);

    // Update State.
    store.dispatch(ReceiveTaskComments(taskComments: newTaskComments));

    var commentRef =
        _getTaskCommentCollectionRef(projectId, taskId).document(commentId);
    var taskRef = _getTasksCollectionRef(projectId).document(taskId);
    var batch = Firestore.instance.batch();

    var commentPreview = _generateTaskCommentPreview(newTaskComments)
        .map((item) => item.toMap())
        .toList();

    batch.delete(commentRef);
    batch.updateData(taskRef, {'commentPreview': commentPreview});

    try {
      await batch.commit();
    } catch (error) {
      throw error;
    }
  };
}

Map<String, dynamic> _buildUnseenTaskCommentMembers(
    List<MemberModel> members, String userId) {
  if (members == null || members.length <= 1) {
    return <String, String>{};
  }

  var otherMembers = members.where((member) => member.userId != userId);

  return Map<String, dynamic>.fromIterable(otherMembers,
      key: (item) {
        var member = item as MemberModel;
        return member.userId;
      },
      value: (item) => "0");
}

List<CommentModel> _generateTaskCommentPreview(
    List<CommentModel> existingTaskComments,
    {CommentModel addedComment,
    CommentModel removedComment}) {
  if (addedComment != null && removedComment != null) {
    throw UnsupportedError(
        '_generateTaskCommentPreview: You can only provide an addedComment OR a removedComment OR neither, not both');
  }

  var list = existingTaskComments.toList();

  if (addedComment != null) {
    list.insert(0, addedComment);
  }

  if (removedComment != null) {
    list.remove(removedComment);
  }

  // We clone the comment elements, because we need to update and mutate the Comment Preview without screwing with
  // the comments that exist in the state.taskComments collection.
  var clonedElements = list.map((item) => item.copy()).toList();

  return clonedElements.reversed
      .take(taskCommentPreviewLimit)
      .toList()
      .reversed
      .toList();
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
    batch.delete(_getTasksCollectionRef(projectId).document(id));
  }

  // Build TaskLists into Batch.
  for (var id in taskListIds) {
    batch.delete(_getTaskListsCollectionRef(projectId).document(id));
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

  return memberList.map((item) => item.userId).toList();
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

ThunkAction<AppState> undo() {
  return (Store<AppState> store) async {
    undoLastAction(store);
  };
}

ThunkAction<AppState> renameTaskListWithDialog(
    String taskListId, String taskListName, BuildContext context) {
  return (Store<AppState> store) async {
    var userId = store.state.user.userId;
    var dialogResult =
        await postTextInputDialog('Rename List', taskListName, context);

    if (dialogResult.result == DialogResult.negative ||
        taskListName?.trim() == dialogResult.value.trim()) {
      return;
    }

    try {
      await _getTaskListsCollectionRef(store.state.selectedProjectId)
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
  var baseTaskRef = _getTasksCollectionRef(store.state.selectedProjectId);
  var taskListRef = _getTaskListsCollectionRef(store.state.selectedProjectId)
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

ThunkAction<AppState> deleteTask(
    String taskId, String projectId, String taskName, BuildContext context) {
  return (Store<AppState> store) async {
    var ref = _getTasksCollectionRef(projectId).document(taskId);

    pushUndoAction(
        DeleteTaskUndoActionModel(
          friendlyName: 'Undo',
          taskRefPath: ref.path,
        ),
        store);

    showSnackBar(
        targetGlobalKey: homeScreenScaffoldKey,
        message: 'Deleted task ${truncateString(taskName)}',
        actionLabel: 'Undo',
        autoHideSeconds: 6,
        onClosed: (reason) {
          if (reason == SnackBarClosedReason.action) {
            undoLastAction(store);
          }
        });

    try {
      await ref.updateData({'isDeleted': true});
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> updateTaskSorting(String projectId, String taskListId,
    TaskListSettingsModel existingSettings, TaskSorting sorting) {
  return (Store<AppState> store) async {
    if (existingSettings?.sortBy == sorting) {
      return;
    }

    var ref = _getTaskListsCollectionRef(projectId).document(taskListId);
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
    homeScreenScaffoldKey?.currentState?.openDrawer();

    var result = await postTextInputDialog('Add new Project', '', context);
    var userId = store.state.user.userId;

    if (result is TextInputDialogResult &&
        result.result == DialogResult.affirmative) {
      var batch = Firestore.instance.batch();

      // Project Entity Ref.
      var projectRef = _getProjectsCollectionRef(store).document();
      var project = ProjectModel(
        uid: projectRef.documentID,
        projectName: result.value.trim().isEmpty
            ? 'Untitled Project'
            : result.value.trim(),
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

      // Initial TaskList
      var taskListRef =
          _getTaskListsCollectionRef(projectRef.documentID).document();
      var taskList = TaskListModel(
        uid: taskListRef.documentID,
        project: projectRef.documentID,
        taskListName: 'Assorted',
        dateAdded: DateTime.now(),
      );

      batch.setData(projectRef, project.toMap());
      batch.setData(projectIdRef, projectId.toMap());
      batch.setData(memberRef, member.toMap());
      batch.setData(taskListRef, taskList.toMap());

      try {
        await batch.commit();
      } catch (error) {
        throw error;
      }
    }
  };
}

ThunkAction<AppState> handleLogInHintButtonPress() {
  return (Store<AppState> store) async {
    store.dispatch(OpenAppSettings(tab: AppSettingsTabs.account));
  };
}

ThunkAction<AppState> setShowCompletedTasks(
    bool showCompletedTasks, String projectId) {
  return (Store<AppState> store) async {
    if (projectId == null || projectId == '-1') {
      return;
    }

    store.dispatch(
        SetShowCompletedTasks(showCompletedTasks: showCompletedTasks));

    if (showCompletedTasks == true) {
      _firestoreStreams.projectSubscriptions[projectId].completedTasks =
          _subscribeToCompletedTasks(projectId, store);

      // _handleTasksSnapshot will be called for the query and handle everything from here.

    } else {
      await _firestoreStreams.projectSubscriptions[projectId]?.completedTasks
          ?.cancel();

      // _handleTasksSnapshot won't be called, so we need to Animated the Tasks out Manually.

      if (store.state.inflatedProject != null &&
          projectId == store.state.inflatedProject.data.uid) {
        // Animate the completed Tasks out.
        var outgoingTasks = store.state.tasksByProject[projectId]
            .where((task) => task.isComplete == true)
            .toList();
        var preMutationIndices =
            Map<String, int>.from(store.state.inflatedProject.taskIndices);
        var taskAnimationUpdates = outgoingTasks
            .map((task) => TaskAnimationUpdate(
                  index: _getTaskAnimationIndex(preMutationIndices, task.uid),
                  listStateKey: _getAnimatedListStateKey(task.taskList),
                  task: task,
                ))
            .toList();

        store.dispatch(ReceiveCompletedTasks(
          originProjectId: projectId,
          tasks: <TaskModel>[],
        ));

        taskAnimationUpdates.sort(TaskAnimationUpdate.removalSorter);
        _driveTaskRemovalAnimations(taskAnimationUpdates);
      }
    }
  };
}

StreamSubscription<QuerySnapshot> _subscribeToCompletedTasks(
    String projectId, Store<AppState> store) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('tasks')
      .where('isComplete', isEqualTo: true)
      .snapshots()
      .listen((snapshot) => _handleTasksSnapshot(
          TasksSnapshotType.completed, snapshot, projectId, store));
}

ThunkAction<AppState> addNewTaskListWithDialog(
    String projectId, BuildContext context) {
  return (Store<AppState> store) async {
    var result = await postTextInputDialog('Add new List', '', context);

    if (result is TextInputDialogResult &&
        result.result == DialogResult.affirmative) {
      var ref = _getTaskListsCollectionRef(projectId).document();
      var taskList = TaskListModel(
        uid: ref.documentID,
        project: projectId,
        taskListName:
            result.value.trim().isEmpty ? 'Untitled List' : result.value.trim(),
        dateAdded: DateTime.now(),
      );

      try {
        await ref.setData(taskList.toMap());
      } catch (error) {
        throw error;
      }
    } else {
      print('Canceled');
    }
  };
}

ThunkAction<AppState> updateListSorting(
    String projectId, TaskListSorting sorting, BuildContext context) {
  return (Store<AppState> store) async {
    if (sorting == TaskListSorting.custom) {
      var existingTaskLists = store.state.inflatedProject.inflatedTaskLists
          .map((item) => item.data)
          .toList();

      var dialogResult = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              ListSortingScreen(taskLists: existingTaskLists));

      // If dialogResult is null. User did not change any of the order, So we assume they are happy with the ordering as is,
      // and just wanted to activate custom order, so we use the existingTasklists collection to build the ID List. Otherwise,
      // we use what was returned from the Dialog.
      var sortedTaskLists = dialogResult is List<TaskListModel>
          ? dialogResult
          : existingTaskLists;

      var ref =
          _getMembersCollectionRef(projectId).document(store.state.user.userId);

      try {
        await ref.updateData({
          'listCustomSortOrder':
              sortedTaskLists.map((item) => item.uid).toList()
        });
      } catch (error) {
        throw error;
      }
    }

    // Update State
    store.dispatch(SetListSorting(listSorting: sorting));

    // Update on Device Storage.
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('listSorting', convertTaskListSorting(sorting));
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> moveTaskListToProjectWithDialog(String taskListId,
    String projectId, String listName, BuildContext context) {
  return (Store<AppState> store) async {
    var otherProjects =
        store.state.projects.where((item) => item.uid != projectId).toList();

    String targetProjectId;
    if (otherProjects.length == 1) {
      // Only one other option available. Show a simplified Dialog.
      var projectName = otherProjects.first.projectName;
      var result = await postConfirmationDialog(
          'Move list',
          'Are you sure you want to move $listName into $projectName?',
          'Move',
          'Cancel',
          context);

      if (result is DialogResult && result == DialogResult.affirmative) {
        targetProjectId = otherProjects.first.uid;
      }
    } else {
      targetProjectId = await showModalBottomSheet(
          context: context,
          builder: (context) =>
              MoveListBottomSheet(projectOptions: otherProjects));
    }

    if (targetProjectId == null) {
      return;
    }

    moveTaskList(taskListId, projectId, targetProjectId, store.state);

    var targetProjectName = store.state.projects
            .firstWhere((item) => item.uid == targetProjectId,
                orElse: () => null)
            ?.projectName ??
        'Another project';
    showSnackBar(
      targetGlobalKey: homeScreenScaffoldKey,
      message: '$listName moved to $targetProjectName',
      autoHideSeconds: 4,
    );
  };
}

void moveTaskList(String taskListId, String sourceProjectId,
    String targetProjectId, AppState state) async {
  // Prep Tasks.
  List<TaskModel> sourceChildTasks = state.tasksByProject[sourceProjectId]
          ?.where((item) => item.taskList == taskListId)
          ?.toList() ??
      <TaskModel>[];

  List<TaskModel> targetChildTasks = sourceChildTasks
      .map((task) => task.copyWith(project: targetProjectId))
      .toList();

  // Prep TaskList.
  TaskListModel sourceTaskList = state.taskListsByProject[sourceProjectId]
      ?.firstWhere((item) => item.uid == taskListId, orElse: () => null);
  var sourceTaskListRef =
      _getTaskListsCollectionRef(sourceProjectId).document(taskListId);

  if (sourceTaskList == null) {
    return;
  }

  TaskListModel targetTaskList =
      sourceTaskList.copyWith(project: targetProjectId);
  var targetTaskListRef =
      _getTaskListsCollectionRef(targetProjectId).document(taskListId);

  // Everything Prepped. Let's move.
  var batch = Firestore.instance.batch();

  // Write operations to new Location.
  batch.setData(targetTaskListRef, targetTaskList.toMap());
  for (var task in targetChildTasks) {
    batch.setData(_getTasksCollectionRef(targetProjectId).document(task.uid),
        task.toMap());
  }

  // You would think that we would delete the SourceTaskList and SourceTasks here. But doing so would trigger the RemoveOrphanedTaskComments and RemoveOrphanedTasks
  // Cloud Functions, these could possibly delete the Task Comments before the CleanupTaskListMoveJob can get to them (To move completed Tasks and Task Comments).
  // Therefore we just Flag the SourceTaskList as deleted for now. CleanupTaskListMoveJob will delete it when is ready.
  // We only touch the Task List here, Flagging the Tasks will likely cause AnimatedList Issues for now.
  batch.updateData(sourceTaskListRef, {'isDeleted': true});

  var cleanupJob = CleanupTaskListMoveJobModel(
      payload: CleanupTaskListMoveJobPayload(
    sourceProjectId: sourceProjectId,
    targetProjectId: targetProjectId,
    taskListId: taskListId,
    taskIds: targetChildTasks.map((item) => item.uid).toList(),
    sourceTaskListRefPath: sourceTaskListRef.path,
    sourceTasksRefPath: _getTasksCollectionRef(sourceProjectId).path,
    targetTaskListRefPath: targetTaskListRef.path,
    targetTasksRefPath: _getTasksCollectionRef(targetProjectId).path,
  ));

  batch.setData(_getJobsQueueCollectionRef().document(), cleanupJob.toMap());

  try {
    await batch.commit();
  } catch (error) {
    throw error;
  }
}

CollectionReference _getJobsQueueCollectionRef() {
  return Firestore.instance.collection('jobsQueue');
}

ThunkAction<AppState> updateTaskName(String newValue, String oldValue,
    String taskId, String projectId, TaskMetadata existingMetadata) {
  return (Store<AppState> store) async {
    if (newValue?.trim() == oldValue?.trim()) {
      return;
    }

    newValue = newValue.trim();
    var batch = Firestore.instance.batch();
    var ref = _getTasksCollectionRef(projectId).document(taskId);

    if (TaskArgumentParser.hasArguments(newValue) == true) {
      var parser =
          TaskArgumentParser(projectMembers: store.state.members[projectId]);

      var argMap = await parser.parseTextForArguments(newValue);
      if (argMap.assignmentIds != null) {
        batch.updateData(ref, {'assignedTo': argMap.assignmentIds});
      }

      if (argMap.dueDate != null) {
        batch.updateData(
            ref, {'dueDate': normalizeDate(argMap.dueDate).toIso8601String()});
      }

      if (argMap.isHighPriority != null) {
        batch.updateData(ref, {'isHighPriority': argMap.isHighPriority});
      }

      if (argMap.note != null) {
        batch.updateData(ref, {'note': argMap.note});
      }
    }

    batch.updateData(
        ref, {'taskName': TaskArgumentParser.trimArguments(newValue)});
    batch.updateData(ref, {
      'metadata': _getUpdatedTaskMetadata(existingMetadata,
              TaskMetadataUpdateType.updated, store.state.user.displayName)
          .toMap()
    });

    try {
      await batch.commit();
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

    var assignmentOptions = store.state.members[projectId] == null
        ? <Assignment>[]
        : store.state.members[projectId]
            .map((item) =>
                Assignment(userId: item.userId, displayName: item.displayName))
            .toList();

    var result = await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => AddTaskDialog(
            preselectedTaskList: preselectedTaskList,
            taskLists: store.state.taskListsByProject[projectId],
            allowTaskListChange: taskListId == null,
            assignmentOptions: assignmentOptions,
            memberLookup: store.state.memberLookup,
            isProjectShared: store.state.members[projectId] != null &&
                store.state.members[projectId].length > 1,
          ),
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
        var taskListRef = _getTaskListsCollectionRef(projectId).document();

        var newTaskList = TaskListModel(
          uid: taskListRef.documentID,
          project: projectId,
          taskListName: result.taskListName.trim().isEmpty
              ? 'Untitled List'
              : result.taskListName.trim(),
          dateAdded: DateTime.now(),
        );

        // New Task
        var taskRef = _getTasksCollectionRef(projectId).document();
        var task = TaskModel(
            uid: taskRef.documentID,
            taskList: newTaskList.uid,
            project: projectId,
            userId: store.state.user.userId,
            taskName: result.taskName.trim().isEmpty
                ? 'Untitled Task'
                : result.taskName.trim(),
            dueDate: result.selectedDueDate,
            isHighPriority: result.isHighPriority,
            dateAdded: DateTime.now(),
            assignedTo: result.assignedToIds,
            note: result.note,
            metadata: TaskMetadata(
              createdBy: store.state.user.displayName,
              createdOn: DateTime.now(),
            ));

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
        var taskRef = _getTasksCollectionRef(projectId).document();
        var targetTaskListId = result.taskListId ??
            taskListId; // Use the taskListId parameter if Dialog returns a null taskListId.

        var task = TaskModel(
            uid: taskRef.documentID,
            taskList: targetTaskListId,
            userId: store.state.user.userId,
            project: projectId,
            taskName: result.taskName.trim().isEmpty
                ? 'Untitled Task'
                : result.taskName.trim(),
            dueDate: result.selectedDueDate,
            isHighPriority: result.isHighPriority,
            dateAdded: DateTime.now(),
            assignedTo: result.assignedToIds,
            note: result.note,
            metadata: TaskMetadata(
                createdBy: store.state.user.displayName,
                createdOn: DateTime.now()));

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
  // 4. Check if only one TaskList is available.

  // First try and retrieve directly.
  if (taskListId != null && taskListId != '-1') {
    var extractedTaskList = state.taskListsByProject[projectId]
        .firstWhere((item) => item.uid == taskListId, orElse: () => null);
    if (extractedTaskList != null) {
      return extractedTaskList;
    }
  }

  // Retreiving directly failed, probably because no taskListId was provided to begin with.
  // So now try and retrieve from lastUsedTaskLists.
  var lastUsedTaskListId = state.lastUsedTaskLists[projectId];
  if (lastUsedTaskListId != null) {
    var extractedTaskList = state.taskListsByProject[projectId].firstWhere(
        (item) => item.uid == lastUsedTaskListId,
        orElse: () => null);

    if (extractedTaskList != null) {
      return extractedTaskList;
    }
  }

  if (state.taskListsByProject[projectId].length == 1) {
    return state.taskListsByProject[projectId].first;
  }

  // Everything has Failed. TaskList could not be retrieved.
  return null;
}

ThunkAction<AppState> updateTaskComplete(
    String taskId, bool newValue, TaskMetadata existingMetadata) {
  return (Store<AppState> store) async {
    var userId = store.state.user.userId;
    var ref =
        _getTasksCollectionRef(store.state.selectedProjectId).document(taskId);
    try {
      await ref.updateData({'isComplete': newValue});
      await ref.updateData({
        'metadata': _getUpdatedTaskMetadata(existingMetadata,
                TaskMetadataUpdateType.completed, store.state.user.displayName)
            .toMap(),
      });
    } catch (error) {
      throw error;
    }
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

    // Don't add lists Flagged as Deleted.
    if (taskList.isDeleted != true) {
      taskLists.add(taskList);

      if (taskList.settings?.checklistSettings?.isChecklist == true) {
        checklists.add(taskList);
      }
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

  // 'unComplete' related Tasks.
  var batch = Firestore.instance.batch();
  var snapshot = await _getTasksCollectionRef(checklist.project)
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

    var ref =
        _getTaskListsCollectionRef(checklist.project).document(checklist.uid);

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
      .listen((snapshot) => _handleTasksSnapshot(
          TasksSnapshotType.incompleted, snapshot, projectId, store));
}

void _handleTasksSnapshot(TasksSnapshotType type, QuerySnapshot snapshot,
    String originProjectId, Store<AppState> store) {
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

  if (store.state.selectedProjectId == originProjectId) {
    // Animation.
    var groupedDocumentChanges = _getGroupedTaskDocumentChanges(
        snapshot.documentChanges,
        store.state.inflatedProject,
        store.state.tasksByProject[originProjectId],
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
    _driveTaskRemovalAnimations(_getTaskRemovalAnimationUpdates(
        groupedDocumentChanges.removed,
        preMutationTaskIndices,
        store.state.user.userId));

    // Additons.
    _driveTaskAdditionAnimations(_getTaskAdditionAnimationUpdates(
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

List<TaskAnimationUpdate> _getTaskRemovalAnimationUpdates(
    List<CustomDocumentChange> removedCustomDocumentChanges,
    Map<String, int> preMutationTaskIndices,
    String userId) {
  var list = removedCustomDocumentChanges.map((change) {
    return TaskAnimationUpdate(
      task: TaskModel.fromDoc(change.document, userId),
      index: _getTaskAnimationIndex(preMutationTaskIndices, change.uid),
      listStateKey: _getAnimatedListStateKey(change.taskList),
    );
  }).toList();

  list.sort(TaskAnimationUpdate.removalSorter);
  return list;
}

List<TaskAnimationUpdate> _getTaskAdditionAnimationUpdates(
    List<CustomDocumentChange> addedCustomDocumentChanges,
    Map<String, int> postMutationTaskIndices) {
  var list = addedCustomDocumentChanges.map((docChange) {
    return TaskAnimationUpdate(
      index: _getTaskAnimationIndex(
          postMutationTaskIndices, docChange.document.documentID),
      listStateKey:
          _getAnimatedListStateKey(docChange.document.data['taskList']),
      task: null, // Additions don't require the actual Task.
    );
  }).toList();

  list.sort(TaskAnimationUpdate.additionSorter);
  return list;
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
      .listen((doc) async {
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
        var ref =
            _getTaskListsCollectionRef(taskList.project).document(taskList.uid);
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

CollectionReference _getTaskCommentCollectionRef(
  String projectId,
  String taskId,
) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('tasks')
      .document(taskId)
      .collection('taskComments');
}

CollectionReference _getMembersCollectionRef(
  String projectId,
) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('members');
}

CollectionReference _getTasksCollectionRef(String projectId) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('tasks');
}

CollectionReference _getTaskListsCollectionRef(String projectId) {
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

GroupedTaskDocumentChanges _getGroupedTaskDocumentChanges(
    List<DocumentChange> firestoreDocChanges,
    InflatedProjectModel currentInflatedProject,
    List<TaskModel> existingTasks,
    Map<String, TaskModel> flaggedAsDeletedTasks,
    Map<String, TaskModel> existingTasksById) {
  var groupedChanges = GroupedTaskDocumentChanges();

  for (var change in firestoreDocChanges) {
    if (change.type == DocumentChangeType.removed) {
      groupedChanges.removed.add(CustomDocumentChange(
        uid: change.document.documentID,
        taskList: change.document.data['taskList'],
        document: change.document,
      ));
    }

    if (change.type == DocumentChangeType.modified) {
      groupedChanges.modified.add(CustomDocumentChange(
        uid: change.document.documentID,
        taskList: change.document.data['taskList'],
        document: change.document,
      ));

      if (currentInflatedProject != null &&
          currentInflatedProject.data.uid == change.document.data['project']) {
        // We may need to adjust what is in the added, modifed and removed collections to appease the Task AnimatedList.
        if (_didMoveTaskList(change.document, existingTasks)) {
          // A Task has moved. Whilst the project is selected. The Animation system won't catch it if we leave it
          // simply as a modified Task. Therefore, we need to add the old version of the Task to the removed collection then
          // add the new version (with the updated taskList field) to the added collection.
          var oldTask = existingTasks.firstWhere(
              (item) => item.uid == change.document.documentID,
              orElse: () => null);

          if (oldTask != null) {
            groupedChanges.removed.add(CustomDocumentChange(
              uid: change.document.documentID,
              taskList: oldTask.taskList,
              document: change.document,
            ));

            groupedChanges.added.add(CustomDocumentChange(
              uid: change.document.documentID,
              taskList: change.document.data['taskList'],
              document: change.document,
            ));
          }
        }

        // Task has been flagged as Deleted.
        if (flaggedAsDeletedTasks.containsKey(change.document.documentID)) {
          groupedChanges.removed.add(CustomDocumentChange(
            uid: change.document.documentID,
            taskList: change.document.data['taskList'],
            document: change.document,
          ));
        }

        // Task has been un-flagged as Deleted.
        // We infer this by checking if the task exists in the State. Because we don't add tasks that have been flagged as deleted to State. We can safely assume
        // that the task has been un-deleted on account of the fact that we are in the Firestore Modified doc changes.. ie Firestore thinks we already have this task
        // in State.
        // *********
        // IF THIS FAILS IN FUTURE
        // *********
        // Don't panic. Just Save the deleted tasks into the State, but put them in a seperate map. That way, here can compare against that map to determine if the task has
        // been un-deleted.
        if (existingTasksById.containsKey(change.document.documentID) == false) {
          groupedChanges.added.add(CustomDocumentChange(
            uid: change.document.documentID,
            taskList: change.document.data['taskList'],
            document: change.document,
          ));
        }
      }
    }

    if (change.type == DocumentChangeType.added) {
      groupedChanges.added.add(CustomDocumentChange(
        uid: change.document.documentID,
        taskList: change.document.data['taskList'],
        document: change.document,
      ));
    }
  }

  return groupedChanges;
}

bool _didMoveTaskList(
    DocumentSnapshot incomingDoc, List<TaskModel> existingTasks) {
  var taskId = incomingDoc.documentID;
  var existingTask = existingTasks.firstWhere((item) => item.uid == taskId,
      orElse: () => null);

  if (existingTask == null) {
    return false;
  }

  return existingTask.taskList != incomingDoc.data['taskList'];
}

void _driveTaskAdditionAnimations(
    List<TaskAnimationUpdate> taskAnimationUpdates) {
  /*
    WHAT THE F**K?
    AnimatedLists and their component removeItem() and insertItem() methods are designed to really only deal with single
    mutations at a time. When you try and make multiple mutations in one pass, you have to make sure that the index is
    updated for each following item, otherwise the AnimatedList will try to start removing items at incorrect indexes,
    throwing an out of range index exception. The easiest way to do this is to Build the doc changes into a List of
    TaskAnimationUpdate objects, then sort them by TaskList, then index in descending order. That way, we don't have to
    adjust any following indexes as we are mutating the AnimatedList.
  */

  for (var update in taskAnimationUpdates) {
    var index = update.index;
    var listStateKey = update.listStateKey;

    if (index != null && listStateKey?.currentState != null) {
      // If the index is null, that means that the parent TaskList isn't on Device yet, Don't PANIC! We can just ignore
      // the Animation Update of that Task because once the TaskList arrives, it will be rendered in the initialRender of
      // list anyway.
      listStateKey.currentState.insertItem(index);
    }
  }
}

void _driveTaskRemovalAnimations(
    List<TaskAnimationUpdate> taskRemovalAnimationUpdates) {
  /*
    WHAT THE F**K?
    AnimatedLists and their component removeItem() and insertItem() methods are designed to really only deal with single
    mutations at a time. When you try and make multiple mutations in one pass, you have to make sure that the index is
    updated for each following item, otherwise the AnimatedList will try to start removing items at incorrect indexes,
    throwing an out of range index exception. The easiest way to do this is to Build the doc changes into a List of
    TaskAnimationUpdate objects, then sort them by TaskList, then index in descending order. That way, we don't have to
    adjust any following indexes as we are mutating the AnimatedList.
  */

  for (var update in taskRemovalAnimationUpdates) {
    var index = update.index;
    var listStateKey = update.listStateKey;
    var task = update.task;

    if (index != null && listStateKey?.currentState != null) {
      listStateKey.currentState.removeItem(index, (context, animation) {
        return SizeTransition(
            sizeFactor: animation,
            axis: Axis.vertical,
            child: Task(
              key: Key(task.uid),
              model: TaskViewModel(data: task),
            ));
      }, duration: Duration(milliseconds: 150));
    }
  }
}

int _getTaskAnimationIndex(Map<String, int> indices, String taskId) {
  return indices[taskId];
}

GlobalKey<AnimatedListState> _getAnimatedListStateKey(String taskListId) {
  return taskListAnimatedListStateKeys[taskListId];
}

TaskMetadata _getUpdatedTaskMetadata(
    TaskMetadata existingMetadata, TaskMetadataUpdateType type, String by) {
  var metadata = existingMetadata ?? TaskMetadata();

  switch (type) {
    case TaskMetadataUpdateType.created:
      return metadata.copyWith(createdBy: by, createdOn: DateTime.now());

    case TaskMetadataUpdateType.completed:
      return metadata.copyWith(
        completedBy: by,
        completedOn: DateTime.now(),
      );

    case TaskMetadataUpdateType.updated:
      // Ignore any calls to update metadata if it hasn't been at least two minutes since metadata creation.
      if (metadata.createdOn != null &&
          DateTime.now().difference(metadata.createdOn).inMinutes > 2) {
        return metadata.copyWith(
          updatedBy: by,
          updatedOn: DateTime.now(),
        );
      }

      return metadata.copyWith();

    default:
      return metadata.copyWith();
  }
}
