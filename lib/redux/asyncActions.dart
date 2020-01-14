import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handball_flutter/SharedPreferencesKeys.dart';
import 'package:handball_flutter/configValues.dart';
import 'package:handball_flutter/containers/AddTaskDialogContainer.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/globals.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/models/AccountConfig.dart';
import 'package:handball_flutter/models/ActivityFeedEventModel.dart';
import 'package:handball_flutter/models/AppTheme.dart';
import 'package:handball_flutter/models/ArchivedProject.dart';
import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/models/ChecklistSettings.dart';
import 'package:handball_flutter/models/Comment.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/ProjectIdModel.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Reminder.dart';
import 'package:handball_flutter/models/ServerCleanupJobs/CleanupTaskListMove.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/TaskListSettings.dart';
import 'package:handball_flutter/models/TaskMetadata.dart';
import 'package:handball_flutter/models/TextInputDialogModel.dart';
import 'package:handball_flutter/models/UndoActions/CompleteTaskUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/DeleteProjectUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/DeleteTaskListUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/DeleteTaskUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/MultiCompleteTasksUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/MultiDeleteTasksUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/NoAction.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:handball_flutter/presentation/Dialogs/AccountReauthenticationDialog/AccountReauthenticationDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/AddTaskDialog/AddTaskDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/AddTaskDialog/TaskListColorSelectDialog/TaskListColorSelectDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/ArchivedProjectsBottomSheet/ArchivedProjectsBottomSheet.dart';
import 'package:handball_flutter/presentation/Dialogs/ChangeDisplayNameDialog/ChangeDisplayNameDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/ChangeEmailDialog/ChangeEmailDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/ChangePasswordDialog/ChangePasswordDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/ChecklistSettingsDialog/ChecklistSettingsDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/ChooseAssignmentDialog/ChooseAssignmentDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/DeleteAccountDialog/DeleteAccountDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/DeleteAccountDialog/DeleteAccountInProgressMask.dart';
import 'package:handball_flutter/presentation/Dialogs/ForgotPasswordDialog/ForgotPasswordDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/LogInDialog/LogInDialog.dart';
import 'package:handball_flutter/presentation/Dialogs/MoveListBottomSheet.dart';
import 'package:handball_flutter/presentation/Dialogs/MoveTasksDialog/MoveTaskBottomSheet.dart';
import 'package:handball_flutter/presentation/Screens/ListSortingScreen/ListSortingScreen.dart';
import 'package:handball_flutter/presentation/Screens/SignUp/SignUpBase.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/redux/syncActions.dart';
import 'package:handball_flutter/utilities/CloudFunctionLayer.dart';
import 'package:handball_flutter/utilities/PlayStore/handlePurchaseUpdates.dart';
import 'package:handball_flutter/utilities/Reminders/buildNewRemindersMap.dart';
import 'package:handball_flutter/utilities/Reminders/initializeLocalNotifications.dart';
import 'package:handball_flutter/utilities/TaskAnimationUpdate.dart';
import 'package:handball_flutter/utilities/TaskArgumentParser/TaskArgumentParser.dart';
import 'package:handball_flutter/utilities/UndoRedo/parseUndoAction.dart';
import 'package:handball_flutter/utilities/UndoRedo/pushUndoAction.dart';
import 'package:handball_flutter/utilities/UndoRedo/undoLastAction.dart';
import 'package:handball_flutter/utilities/activivtyFeedUpdaters.dart';
import 'package:handball_flutter/utilities/authExceptionHandlers.dart';
import 'package:handball_flutter/utilities/buildInflatedProject.dart';
import 'package:handball_flutter/utilities/checklistHelpers.dart';
import 'package:handball_flutter/utilities/convertMemberRole.dart';
import 'package:handball_flutter/utilities/dialogPosters.dart';
import 'package:handball_flutter/utilities/extractListCustomSortOrder.dart';
import 'package:handball_flutter/utilities/extractProject.dart';
import 'package:handball_flutter/utilities/firestoreReferenceGetters.dart';
import 'package:handball_flutter/utilities/firestoreSubscribers.dart';
import 'package:handball_flutter/utilities/isSameTime.dart';
import 'package:handball_flutter/utilities/listSortingHelpers.dart';
import 'package:handball_flutter/utilities/mergeLastUsedTaskList.dart';
import 'package:handball_flutter/utilities/normalizeDate.dart';
import 'package:handball_flutter/utilities/parseActivityFeedQueryLength.dart';
import 'package:handball_flutter/utilities/quickActionsLayer/quickActionsLayer.dart';
import 'package:handball_flutter/utilities/showSnackbar.dart';
import 'package:handball_flutter/utilities/snapshotHandlers.dart';
import 'package:handball_flutter/utilities/taskAnimationHelpers.dart';
import 'package:handball_flutter/utilities/truncateString.dart';
import 'package:handball_flutter/utilities/validateDisplayName.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final CloudFunctionsLayer _cloudFunctionsLayer = CloudFunctionsLayer();

StreamSubscription<List<PurchaseDetails>> _purchaseUpdateStreamSubscription;

ThunkAction<AppState> updateTaskReminder(DateTime newValue,
    DateTime existingValue, String taskId, String taskName, String projectId) {
  return (Store<AppState> store) async {
    if (isSameTime(newValue, existingValue)) {
      return;
    }

    var userId = store.state.user.userId;

    // User has removed Reminder.
    if (newValue == null) {
      var ref = getTasksCollectionRef(projectId).document(taskId);

      try {
        await ref.updateData({'reminders.$userId': FieldValue.delete()});
      } catch (error) {
        throw error;
      }
    } else {
      // User has updated Reminder Time.
      var reminder = ReminderModel(
        originTaskId: taskId,
        time: newValue,
        title: taskReminderTitle,
        message: truncateString(taskName, taskReminderMessageLength),
        userId: userId,
        isSeen: false,
      );

      var ref = getTasksCollectionRef(projectId).document(taskId);

      try {
        ref.updateData({'reminders.$userId': reminder.toMap()});
      } catch (error) {
        throw error;
      }
    }
  };
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

      var ref = getProjectsCollectionRef().document(projectId);

      // Activity Feed.
      updateActivityFeed(
        user: store.state.user,
        projectId: projectId,
        projectName: existingName,
        type: ActivityFeedEventType.renameProject,
        title: 'renamed the project $existingName to $newName.',
        details: '',
      );

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
    // Auth Listener
    auth.onAuthStateChanged
        .listen((user) => handleAuthStateChanged(store, user));

    // Shared Preferences
    _initializeAndFetchSharedPreferences(store);

    // Notifications.
    initializeLocalNotifications(store);

    // Quick Actions - Home screen shortcuts.
    QuickActionsLayer.initialize(store);

    // Debugging.
    //_printPendingNotifications();

    // Firestore settings.
    // TODO: Is this even doing anything?
    Firestore.instance.settings();

    // In App Purchases.
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _purchaseUpdateStreamSubscription = purchaseUpdates
        .listen((purchases) => handlePurchaseUpdates(purchases, store));

    // Stripe.
    //StripeSource.setPublishableKey("pk_test_5utVgPAtC8r6wNUtFzlSZAnE00BhffRN0G");
  };
}

void _updateSplashScreen(FirebaseAuth auth, bool wasLoggedIn,
    bool hasLoggedInBefore, Store<AppState> store) async {
  final currentUser = await auth.currentUser();

  if (wasLoggedIn == true && currentUser != null) {
    // Existing User.
    store.dispatch(SetSplashScreenState(state: SplashScreenState.home));
    homeScreenScaffoldKey?.currentState?.openDrawer();
    return;
  }

  if (hasLoggedInBefore == false &&
      wasLoggedIn == false &&
      currentUser == null) {
    // New User
    store.dispatch(SetSplashScreenState(state: SplashScreenState.onboarding));
    return;
  }

  if (hasLoggedInBefore == true &&
      wasLoggedIn == false &&
      currentUser == null) {
    // Returning user but they are logged out.
    store.dispatch(SetSplashScreenState(state: SplashScreenState.loggedOut));
  }
}

void _initializeAndFetchSharedPreferences(Store<AppState> store) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // If the state.user has already been set. That means we have been beaten by onAuthStateChange. So no need to push lastUsedTheme.
  if (store.state.user == null) {
    AppThemeModel lastUsedTheme = AppThemeModel.fromJSON(
        prefs.getString(lastUsedAppThemeSharedPreferencesKey));
    if (lastUsedTheme != null) {
      store.dispatch(ReceiveAccountConfig(
          accountConfig: AccountConfigModel(appTheme: lastUsedTheme)));
    }
  }

  // Splash Screen
  _updateSplashScreen(
      auth,
      prefs.getBool(wasLoggedInSharedPreferencesKey) ?? false,
      prefs.containsKey(hasLoggedInBeforeSharedPreferencesKey),
      store);

  // Fetch lastUsedTaskListIds.
  final jsonDecoder = JsonDecoder();
  final lastUsedTaskListsRawString =
      prefs.getString(lastUsedTaskListIdsSharedPreferencesKey);
  if (lastUsedTaskListsRawString != null && lastUsedTaskListsRawString != '') {
    final lastUsedTaskListIds = Map<String, String>.from(
        jsonDecoder.convert(lastUsedTaskListsRawString));
    store.dispatch(SetLastUsedTaskLists(value: lastUsedTaskListIds));
  }

  // Fetch listSorting.
  TaskListSorting listSorting =
      parseTaskListSorting(prefs.getString(listSortingSharedPreferencesKey));
  store.dispatch(SetListSorting(listSorting: listSorting));

  var lastUndoAction =
      parseUndoAction(prefs.getString(undoActionSharedPreferencesKey));

  store.dispatch(SetLastUndoAction(
      lastUndoAction: lastUndoAction ?? NoAction(), isInitializing: true));
}

ThunkAction<AppState> debugButtonPressed() {
  return (Store<AppState> store) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await prefs.reload();
    showSnackBar(
        message: 'SharedPreferences Cleared.',
        targetGlobalKey: homeScreenScaffoldKey);
  };
}

void _persistAuthState(bool isLoggedIn) async {
  final prefs = await SharedPreferences.getInstance();

  if (isLoggedIn == true) {
    prefs.setBool(wasLoggedInSharedPreferencesKey, isLoggedIn);
    prefs.setBool(hasLoggedInBeforeSharedPreferencesKey, true);
  } else {
    prefs.setBool(wasLoggedInSharedPreferencesKey, isLoggedIn);
  }
}

void handleAuthStateChanged(Store<AppState> store, FirebaseUser user) async {
  if (user == null) {
    store.dispatch(SignOut());
    await firestoreStreams.cancelAll();
    firestoreStreams.projectSubscriptions.clear();
    notificationsPlugin.cancelAll();
    _persistAuthState(false);
    return;
  }

  store.dispatch(SignIn(
      user: new UserModel(
          isLoggedIn: true,
          displayName: user.displayName,
          userId: user.uid,
          email: user.email)));

  subscribeToDatabase(store, user.uid);
  _persistAuthState(true);

  // TODO: Sort this code out below. You are trying to extract the User document. But if it is the users first time Logging in. It won't exist yet.
  // We could use that to detect first Account Log in and activation.
  // But perhaps it would be better to handle this differently. As storage pressure could cause Firestore to drop the user document from it's cache, which would make the
  // app think its a first time log in if the user is offline. So perhaps we should store on device if the user was last a Pro or not, and honor that until we can make a seperate
  // call to check their status. Don't store their purchase IDs though.

  // var userDoc =
  //     await Firestore.instance.collection('users').document(user.uid).get();
  // if (userDoc.exists) {
  //   store.dispatch(SignIn(user: UserModel.fromDoc(userDoc, true)));

  //   subscribeToDatabase(store, user.uid);
  // } else {
  //   // TODO: Handle Log in error, userDoc did not exist. User Could be a new User.
  //   print("Could not find User");
  // }
}

ThunkAction<AppState> showLogInDialog(BuildContext context) {
  return (Store<AppState> store) async {
    if (store.state.user != null && store.state.user.isLoggedIn) {
      // Don't show this Dialog if we are already Logged in.
      return;
    }

    final result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => LogInDialog(
              auth: auth,
              hideSignUpButton: true,
            ));

    if (result is bool && result == true) {
      // Log in was Successful.
      store.dispatch(SetSplashScreenState(state: SplashScreenState.home));
      homeScreenScaffoldKey?.currentState?.openDrawer();
      return;
    }
  };
}

ThunkAction<AppState> deleteAccountWithDialog(BuildContext context) {
  return (Store<AppState> store) async {
    if (store.state.user == null || store.state.user.isLoggedIn == false) {
      return;
    }

    final reAuthResult = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AccountReauthenticationDialog(auth: auth));

    if (reAuthResult == null ||
        (reAuthResult is bool && reAuthResult == false)) {
      return;
    }

    final dialogResult = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => DeleteAccountDialog());

    if (dialogResult is String &&
        dialogResult == deleteAccountConfirmationResult) {
      // User has requested an account Delete.
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DeleteAccountInProgressMask(),
        fullscreenDialog: true,
      ));

      // Collect current User Data and trigger the Delete.
      final user = await auth.currentUser();
      if (user == null) {
        // Uh oh. Something went wrong.
      }

      // This will log the user out. A cloud function will Trigger on auth.deleteUser and handle the rest.
      await user.delete();
      Navigator.of(context).popUntil((route) => route.isFirst == true);
    }
  };
}

ThunkAction<AppState> acceptProjectInvite(String projectId) {
  return (Store<AppState> store) async {
    _addProcessingProjectInviteId(projectId, store);

    try {
      await _cloudFunctionsLayer.acceptProjectInvite(projectId: projectId);
      await _removeProjectInvite(store.state.user.userId, projectId);

      _removeProccessingProjectInviteId(projectId, store);
    } catch (error) {
      _removeProccessingProjectInviteId(projectId, store);
      throw error;
    }
  };
}

ThunkAction<AppState> updateAppTheme(AppThemeModel newAppTheme) {
  return (Store<AppState> store) async {
    if (newAppTheme == null || store.state.user.isLoggedIn == false) {
      return;
    }

    if (store.state.accountConfig == null ||
        store.state.accountConfig.isDefault) {
      // Account Config doesn't exist yet.
      var accountConfigRef =
          getAccountConfigDocumentReference(store.state.user.userId);
      var newAccountConfig = AccountConfigModel(appTheme: newAppTheme);
      await accountConfigRef.setData(newAccountConfig.toMap());
    } else {
      // Account Config already Exists.
      var ref = getAccountConfigDocumentReference(store.state.user.userId);
      await ref.updateData({'appTheme': newAppTheme.toMap()});
    }
  };
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

    store.dispatch(SetInflatedProject(inflatedProject: inflatedProject));
    store.dispatch(SetShowOnlySelfTasks(showOnlySelfTasks: showOnlySelfTasks));

    if (showOnlySelfTasks == true) {
      var removalAnimationUpdates = hiddenTasks.map((task) {
        return TaskAnimationUpdate(
            index: getTaskAnimationIndex(preMutationTaskIndices, task.uid),
            listStateKey: getAnimatedListStateKey(task.taskList),
            task: task);
      }).toList();

      removalAnimationUpdates.sort(TaskAnimationUpdate.removalSorter);

      driveTaskRemovalAnimations(
          removalAnimationUpdates, store.state.memberLookup);
    } else {
      var additionAnimationUpdates = hiddenTasks.map((task) {
        return TaskAnimationUpdate(
          index: getTaskAnimationIndex(postMutationTaskIndices, task.uid),
          listStateKey: getAnimatedListStateKey(task.taskList),
          task: null,
        );
      }).toList();

      additionAnimationUpdates.sort(TaskAnimationUpdate.additionSorter);
      driveTaskAdditionAnimations(additionAnimationUpdates);
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
    if (tasks == null || tasks.isEmpty || sortedTaskLists == null) {
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
        var ref = getTaskListsCollectionRef(projectId).document();
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
            store.state.user.displayName, store.state);
      } catch (error) {
        throw error;
      }
    }
  };
}

Future<void> moveTasks(List<TaskModel> tasks, String destinationTaskListId,
    String projectId, WriteBatch batch, String displayName, AppState state) {
  var projectName = _getProjectName(state.projects, projectId);
  var destinationTaskListName = _getTaskListName(
      state.taskListsByProject[projectId], destinationTaskListId);

  for (var task in tasks) {
    var ref = getTasksCollectionRef(projectId).document(task.uid);
    batch.updateData(ref, {'taskList': destinationTaskListId});
    batch.updateData(ref, {
      'metadata': _getUpdatedTaskMetadata(
              task.metadata, TaskMetadataUpdateType.updated, displayName)
          .toMap(),
    });

    // Activity Feed
    updateActivityFeedToBatch(
        batch: batch,
        projectId: projectId,
        user: state.user,
        projectName: projectName,
        type: ActivityFeedEventType.moveTask,
        title: 'moved a task into $destinationTaskListName.',
        details: task.taskName);
  }

  return batch.commit();
}

ThunkAction<AppState> denyProjectInvite(String projectId) {
  return (Store<AppState> store) async {
    _addProcessingProjectInviteId(projectId, store);
    try {
      await _cloudFunctionsLayer.denyProjectInvite(projectId: projectId);
      await _removeProjectInvite(store.state.user.userId, projectId);
      _removeProccessingProjectInviteId(projectId, store);
    } catch (error) {
      _removeProccessingProjectInviteId(projectId, store);
      throw error;
    }
  };
}

Future<void> _removeProjectInvite(String userId, String projectId) async {
  var ref = getInvitesCollectionRef(userId).document(projectId);
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
    } else {
      // User was located in the directory.
      try {
        print(response.email);
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

        updateActivityFeed(
          projectId: sourceProjectId,
          projectName: _getProjectName(store.state.projects, sourceProjectId),
          user: store.state.user,
          type: ActivityFeedEventType.addMember,
          title:
              'invited ${response.displayName} to contribute to $projectName.',
          details: '',
        );

        showSnackBar(
            targetGlobalKey: shareScreenScaffoldKey,
            message: 'Invite sent to ${response.displayName}.');
        store.dispatch(SetIsInvitingUser(isInvitingUser: false));
      } catch (error) {
        store.dispatch(SetIsInvitingUser(isInvitingUser: false));
        throw error;
      }
    }
  };
}

ThunkAction<AppState> signInUser(
    String email, String password, BuildContext context) {
  return (Store<AppState> store) async {
    store.dispatch(SetAccountState(accountState: AccountState.loggingIn));
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on PlatformException catch (error) {
      store.dispatch(SetAccountState(accountState: AccountState.loggedOut));
      handleAuthException(error, appSettingsScaffoldKey);
    }
  };
}

ThunkAction<AppState> signOutUser() {
  return (Store<AppState> store) async {
    try {
      await auth.signOut();
      store.dispatch(SetSplashScreenState(state: SplashScreenState.loggedOut));
      store.dispatch(CloseAppSettings());
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
      store.dispatch(SetAccountState(accountState: AccountState.loggedOut));
      await Future.delayed(Duration(milliseconds: 500));
      store.dispatch(signInUser(email, password, context));
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> updateTaskPriority(bool newValue, String taskId,
    String projectId, String taskName, TaskMetadata existingMetadata) {
  return (Store<AppState> store) async {
    var ref = getTasksCollectionRef(projectId).document(taskId);

    // Activity Feed.
    final String truncatedTaskName =
        truncateString(taskName, activityFeedTitleTruncationCount);

    updateActivityFeed(
      projectId: projectId,
      user: store.state.user,
      projectName: _getProjectName(store.state.projects, projectId),
      type: newValue == true
          ? ActivityFeedEventType.prioritizeTask
          : ActivityFeedEventType.unPrioritizeTask,
      title: newValue == true
          ? 'flagged the task $truncatedTaskName as high priority.'
          : 'removed the high priorty flag from the task $truncatedTaskName.',
      details: '',
    );

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

ThunkAction<AppState> updateTaskNote(
    String newValue,
    String oldValue,
    String taskId,
    String projectId,
    String taskName,
    TaskMetadata existingMetadata) {
  return (Store<AppState> store) async {
    if (newValue?.trim() == oldValue?.trim()) {
      return;
    }

    var ref = getTasksCollectionRef(projectId).document(taskId);
    var coercedValue = newValue ?? '';

    // Activity Feed.
    updateActivityFeed(
      projectId: projectId,
      user: store.state.user,
      projectName: _getProjectName(store.state.projects, projectId),
      type: ActivityFeedEventType.editTask,
      title:
          'updated the details of the task ${truncateString(taskName, activityFeedTitleTruncationCount)}',
      details: '',
    );

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
    String taskId,
    String projectId,
    String taskName,
    TaskMetadata existingMetadata) {
  return (Store<AppState> store) async {
    var batch = Firestore.instance.batch();
    var ref = getTasksCollectionRef(projectId).document(taskId);

    batch.updateData(ref, {'assignedTo': newAssignments});
    batch.updateData(ref, {
      'metadata': _getUpdatedTaskMetadata(existingMetadata,
              TaskMetadataUpdateType.updated, store.state.user.userId)
          .toMap()
    });

    // Activity Feed.
    final String truncatedTaskName =
        truncateString(taskName, activityFeedTitleTruncationCount);

    if (newAssignments.length == 1) {
      if (newAssignments.first == store.state.user.userId)
        // User has assigned this task to themselves.
        updateActivityFeedToBatch(
          batch: batch,
          projectId: projectId,
          projectName: _getProjectName(store.state.projects, projectId),
          type: ActivityFeedEventType.assignmentUpdate,
          user: store.state.user,
          title: 'assigned the task $truncatedTaskName to ',
          details: '',
          isSelfAssignment: true,
          assignments: newAssignments
              .map((id) =>
                  Assignment.fromMemberModel(store.state.memberLookup[id]))
              .toList(),
        );
      else {
        // User has assigned this task to someone other then themselves.
        updateActivityFeedToBatch(
          batch: batch,
          projectId: projectId,
          projectName: _getProjectName(store.state.projects, projectId),
          type: ActivityFeedEventType.assignmentUpdate,
          user: store.state.user,
          title:
              'assigned the task $truncatedTaskName to ${store.state.memberLookup[newAssignments.first]?.displayName ?? ''}.',
          details: '',
          assignments: newAssignments
              .map((id) =>
                  Assignment.fromMemberModel(store.state.memberLookup[id]))
              .toList(),
        );
      }

      if (newAssignments.length > 1) {
        // User has assigned this task to multiple contributors.
        updateActivityFeedToBatch(
          batch: batch,
          projectId: projectId,
          projectName: _getProjectName(store.state.projects, projectId),
          type: ActivityFeedEventType.assignmentUpdate,
          user: store.state.user,
          title:
              'assigned the task $truncatedTaskName to multiple contributors.',
          details:
              _concatAssignmentsToDisplayNames(newAssignments, store.state),
          assignments: newAssignments
              .map((id) =>
                  Assignment.fromMemberModel(store.state.memberLookup[id]))
              .toList(),
        );
      }
    }

    try {
      await batch.commit();
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> updateTaskDueDate(
    String taskId,
    String projectId,
    DateTime newValue,
    DateTime oldValue,
    String taskName,
    TaskMetadata existingMetadata) {
  return (Store<AppState> store) async {
    if (newValue == oldValue) {
      return;
    }

    var ref =
        getTasksCollectionRef(store.state.selectedProjectId).document(taskId);
    String coercedValue = newValue == null ? '' : newValue.toIso8601String();

    // Activity Feed.
    if (newValue == null) {
      updateActivityFeed(
        projectId: projectId,
        projectName: _getProjectName(store.state.projects, projectId),
        user: store.state.user,
        type: ActivityFeedEventType.changeDueDate,
        title:
            'cleared the due date from the task ${truncateString(taskName, activityFeedTitleTruncationCount)}',
        details: '',
      );
    } else {
      final formatter = DateFormat('MMMMEEEEd');
      final formattedDate = formatter.format(newValue);
      final truncatedTaskName =
          truncateString(taskName, activityFeedTitleTruncationCount);

      updateActivityFeed(
        projectId: projectId,
        projectName: _getProjectName(store.state.projects, projectId),
        user: store.state.user,
        type: ActivityFeedEventType.changeDueDate,
        title: oldValue == null
            ? 'added a due date of $formattedDate to $truncatedTaskName '
            : 'changed the due date of $truncatedTaskName to $formattedDate',
        details: '',
      );
    }

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
        _deleteProject(projectId, projectName, store);
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

bool _canDeleteProject(String userId, List<MemberModel> members) {
  if (members == null || members.isEmpty) {
    return true;
  }

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

    updateActivityFeedWithMemberAction(
      projectId: projectId,
      projectName: _getProjectName(store.state.projects, projectId),
      targetDisplayName: store.state.user.displayName,
      originUserId: store.state.user.userId,
      type: ActivityFeedEventType.removeMember,
      title: 'left the project.',
      details: '',
    );

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
    handleTaskCommentsSnapshot(store, snapshot);
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
    var taskRef = getTasksCollectionRef(projectId).document(taskId);
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
          getTaskCommentCollectionRef(projectId, taskId).document(comment.uid);
      var seenBy = comment.seenBy.toList();
      seenBy.add(userId);
      batch.updateData(commentRef, {'seenBy': seenBy});
    }

    if (commentsNeedingSeenByUpdate.isNotEmpty) {
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

ThunkAction<AppState> paginateTaskComments(String projectId, String taskId) {
  return (Store<AppState> store) async {
    if (store.state.taskComments.isEmpty) {
      return;
    }

    store.dispatch(SetIsPaginatingTaskComments(isPaginatingTaskComments: true));

    var lastCommentDoc = store.state.taskComments.last.docSnapshot;

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
    handleTaskCommentsSnapshot(store, snapshot);
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
    var taskRef = getTasksCollectionRef(projectId).document(taskId);
    var commentRef = getTaskCommentCollectionRef(projectId, taskId).document();

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
        getTaskCommentCollectionRef(projectId, taskId).document(commentId);
    var taskRef = getTasksCollectionRef(projectId).document(taskId);
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
    var memberRef = getMembersCollectionRef(projectId).document(userId);
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
    var memberRef = getMembersCollectionRef(projectId).document(userId);

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

      // Activity Feed.
      updateActivityFeedWithMemberAction(
        projectId: projectId,
        projectName: _getProjectName(store.state.projects, projectId),
        targetDisplayName: displayName,
        originUserId: store.state.user.userId,
        type: ActivityFeedEventType.removeMember,
        title: 'was removed from the project',
        details: '',
      );
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> resetPasswordWithDialog(
    BuildContext context, String currentlyEnteredEmail) {
  return (Store<AppState> store) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ForgotPasswordDialog(
            auth: auth, initialValue: currentlyEnteredEmail));

    // Don't really need to do anything here. ForgotPasswordDialog would have taken care of everything.
  };
}

ThunkAction<AppState> archiveProjectWithDialog(
    String projectId, String projectName, BuildContext context) {
  return (Store<AppState> store) async {
    if (projectId == null || projectName == null) {
      return;
    }

    var message =
        'Are you sure you want to archive $projectName? Archiving a project will hide it from you until you restore it via the General App Settings.';
    var result = await postConfirmationDialog(
        'Archive Project', message, 'Archive', 'Cancel', context);

    if (result == DialogResult.negative) {
      return;
    }

    var ref =
        getProjectIdsCollectionRef(store.state.user.userId).document(projectId);

    try {
      homeScreenScaffoldKey?.currentState?.openDrawer();
      store.dispatch(SelectProject('-1'));

      if (appDrawerScaffoldKey.currentState != null) {
        showSnackBar(
            targetGlobalKey: appDrawerScaffoldKey,
            message: '$projectName archived',
            autoHideSeconds: 4);
      }

      await ref.updateData({
        'isArchived': true,
        'archivedProjectName': projectName,
        'archivedOn': DateTime.now().toIso8601String(),
      });
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> changeEmailWithDialog(BuildContext context) {
  return (Store<AppState> store) async {
    // FIrst Reauthenticate.
    final reAuthResult = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AccountReauthenticationDialog(auth: auth),
    );

    if (reAuthResult == null ||
        (reAuthResult is bool && reAuthResult == false)) {
      return;
    }

    // The dialog will handle everything for us.
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ChangeEmailDialog(
            auth: auth,
            cloudFunctionsLayer: _cloudFunctionsLayer,
            oldEmail: store.state.user.email));
  };
}

ThunkAction<AppState> changePasswordWithDialog(BuildContext context) {
  return (Store<AppState> store) async {
    // First Reauthenticate.
    final reAuthResult = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AccountReauthenticationDialog(auth: auth),
    );

    if (reAuthResult == null ||
        (reAuthResult is bool && reAuthResult == false)) {
      return;
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ChangePasswordDialog(auth: auth),
    );
  };
}

ThunkAction<AppState> changeDisplayNameWithDialog(BuildContext context) {
  return (Store<AppState> store) async {
    final existingDisplayName = store.state.user.displayName;

    final result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ChangeDisplayNameDialog(
            cloudFunctionsLayer: _cloudFunctionsLayer,
            existingValue: existingDisplayName,
            email: store.state.user.email));

    // Dialog handles the call out to Cloud Functions. Will return a string with the new Display Name if it was a success.
    if (result is String && validateDisplayName(result)) {
      store.dispatch(UpdateDisplayName(newDisplayName: result));

      // The server will update the FirebaseUser account. But that doesn't get propagated to logged in devices until they Log out, then log back in.
      // So we trigger the user to Reload to tell Firebase Auth to go and fetch the new Display name.
      final user = await auth.currentUser();
      await user.reload();
    }
  };
}

ThunkAction<AppState> deleteProjectWithDialog(
    String projectId, String projectName, BuildContext context) {
  return (Store<AppState> store) async {
    if (store.state.members[projectId] == null ||
        store.state.members[projectId].length <= 1) {
      // No other Contributors. Simple Delete.
      var dialogResult = await postConfirmationDialog(
          "Delete Project",
          'Are you sure you want to delete $projectName?',
          'Delete',
          'Cancel',
          context);

      if (dialogResult == DialogResult.negative) {
        return;
      }

      await _deleteProject(projectId, projectName, store);
    }

    if (_canDeleteProject(
            store.state.user.userId, store.state.members[projectId]) ==
        false) {
      // User is not allowed to Delete Project.
      await postAlertDialog(
          'Insufficent permissions',
          'Sorry, you do not have permission to delete this project, only Owners can delete projects shared with other contributors.',
          'Okay',
          context);
      return;
    }

    if (store.state.members[projectId] != null &&
        store.state.members[projectId].length > 1) {
      // User has Sufficent privledges to delete project, but project contains other contributors. Inform and Confirm.
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

      await _deleteProject(projectId, projectName, store);
    }
  };
}

Future<void> _deleteProject(
    String projectId, String projectName, Store<AppState> store) async {
  var userId = store.state.user.userId;
  var taskIds = _getProjectRelatedTaskIds(projectId, store.state.tasks);
  var taskListIds =
      _getProjectRelatedTaskListIds(projectId, store.state.taskListsByProject);

  pushUndoAction(
      DeleteProjectUndoActionModel(
        taskIds: taskIds.toList(),
        taskListIds: taskListIds.toList(),
        taskListsPath: getTaskListsCollectionRef(projectId).path,
        tasksPath: getTasksCollectionRef(projectId).path,
        projectIdPath:
            getProjectIdsCollectionRef(userId).document(projectId).path,
        projectPath: getProjectsCollectionRef().document(projectId).path,
      ),
      store);

  showSnackBar(
      targetGlobalKey: appDrawerScaffoldKey,
      message: 'Deleted $projectName',
      actionLabel: 'Undo',
      autoHideSeconds: 6,
      onClosed: (reason) {
        if (reason == SnackBarClosedReason.action) {
          undoLastAction(store);
        }
      });

  var ref = getProjectIdsCollectionRef(userId).document(projectId);

  try {
    var batch = Firestore.instance.batch();

    batch.updateData(ref, {'deleted': Timestamp.fromDate(DateTime.now())});
    batch.updateData(ref, {'isDeleted': true});

    await batch.commit();
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
    final desiredDisplayName = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return SignUpBase(
            firebaseAuth: auth,
            firestore: Firestore.instance,
          );
        });

    if (desiredDisplayName is String) {
      store.dispatch(SetSplashScreenState(state: SplashScreenState.home));
      store.dispatch(InjectDisplayName(displayName: desiredDisplayName));
    }
  };
}

ThunkAction<AppState> undo() {
  return (Store<AppState> store) async {
    undoLastAction(store);
  };
}

ThunkAction<AppState> renameTaskListWithDialog(String taskListId,
    String projectId, String taskListName, BuildContext context) {
  return (Store<AppState> store) async {
    var userId = store.state.user.userId;
    var dialogResult =
        await postTextInputDialog('Rename List', taskListName, context);

    if (dialogResult.result == DialogResult.negative ||
        taskListName?.trim() == dialogResult.value.trim()) {
      return;
    }

    // Activity Feed.
    updateActivityFeed(
      projectId: projectId,
      projectName: _getProjectName(store.state.projects, projectId),
      user: store.state.user,
      type: ActivityFeedEventType.renameList,
      title: 'renamed the list $taskListName to ${dialogResult.value}',
      details: '',
    );

    try {
      await getTaskListsCollectionRef(store.state.selectedProjectId)
          .document(taskListId)
          .updateData({'taskListName': dialogResult.value});
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> deleteTaskListWithDialog(String taskListId,
    String projectId, String taskListName, BuildContext context) {
  return (Store<AppState> store) async {
    var userId = store.state.user.userId;
    var dialogResult = await postConfirmationDialog('Delete List',
        'Are you sure you want to delete $taskListName?', 'Yes', 'No', context);

    if (dialogResult == DialogResult.negative) {
      return;
    }

    showSnackBar(
        targetGlobalKey: homeScreenScaffoldKey,
        message: 'Deleted ${truncateString(taskListName)}',
        actionLabel: 'Undo',
        autoHideSeconds: 6,
        onClosed: (reason) {
          if (reason == SnackBarClosedReason.action) {
            undoLastAction(store);
          }
        });

    // Activity Feed.
    final activityFeedReference = updateActivityFeed(
      projectId: projectId,
      projectName: _getProjectName(store.state.projects, projectId),
      user: store.state.user,
      type: ActivityFeedEventType.renameList,
      title: 'deleted the list $taskListName',
      details: '',
    );

    try {
      await _deleteTaskList(taskListId, store, userId, activityFeedReference);
    } catch (error) {
      throw error;
    }
  };
}

Future _deleteTaskList(String taskListId, Store<AppState> store, String userId,
    DocumentReference activityFeedReference) async {
  var taskIds = _getListRelatedTaskIds(taskListId, store.state.tasks);
  var taskListRef = getTaskListsCollectionRef(store.state.selectedProjectId)
      .document(taskListId);

  pushUndoAction(
      DeleteTaskListUndoActionModel(
          taskListRefPath: taskListRef.path,
          childTaskPaths: taskIds
              .map((id) => getTasksCollectionRef(store.state.selectedProjectId)
                  .document(id)
                  .path)
              .toList(),
          activityFeedReferencePath: activityFeedReference.path),
      store);

  var batch = Firestore.instance.batch();
  batch.updateData(
      taskListRef, ({'isDeleted': Timestamp.fromDate(DateTime.now())}));
  batch.updateData(taskListRef, ({'isDeleted': true}));

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

List<String> _getProjectRelatedTaskListIds(
    String projectId, Map<String, List<TaskListModel>> taskListsByProject) {
  if (taskListsByProject.containsKey(projectId) &&
      taskListsByProject[projectId] != null) {
    return taskListsByProject[projectId].map((list) => list.uid).toList();
  } else {
    return <String>[];
  }
}

ThunkAction<AppState> deleteTask(
  String taskId,
  String projectId,
  String taskName,
  BuildContext context,
) {
  return (Store<AppState> store) async {
    var ref = getTasksCollectionRef(projectId).document(taskId);

    // Activity Feed.
    final activityFeedRef = updateActivityFeed(
      projectId: projectId,
      projectName: _getProjectName(store.state.projects, projectId),
      user: store.state.user,
      type: ActivityFeedEventType.deleteTask,
      title:
          'deleted the task ${truncateString(taskName, activityFeedTitleTruncationCount)}',
      details: '',
    );

    pushUndoAction(
        DeleteTaskUndoActionModel(
          taskRefPath: ref.path,
          activityFeedReferencePath: activityFeedRef.path,
        ),
        store);

    showSnackBar(
        targetGlobalKey: homeScreenScaffoldKey,
        message: 'Deleted ${truncateString(taskName)}',
        actionLabel: 'Undo',
        autoHideSeconds: 6,
        onClosed: (reason) {
          if (reason == SnackBarClosedReason.action) {
            undoLastAction(store);
          }
        });

    try {
      var batch = Firestore.instance.batch();
      batch.updateData(ref, {'deleted': Timestamp.fromDate(DateTime.now())});
      batch.updateData(ref, {'isDeleted': true});

      await batch.commit();
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

    var ref = getTaskListsCollectionRef(projectId).document(taskListId);
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
      var projectRef = getProjectsCollectionRef().document();
      var project = ProjectModel(
        uid: projectRef.documentID,
        projectName: result.value.trim().isEmpty
            ? 'Untitled Project'
            : result.value.trim(),
        created: DateTime.now().toIso8601String(),
      );

      // Project ID Ref.
      var projectIdRef =
          getProjectIdsCollectionRef(userId).document(projectRef.documentID);
      var projectId = ProjectIdModel(
        uid: projectRef.documentID,
        archivedOn: null,
        archivedProjectName: null,
        isArchived: false,
      );

      // Member Ref.
      var memberRef = getProjectMembersCollectionRef(projectRef.documentID)
          .document(userId);
      var member =
          store.state.user.toMember(MemberRole.owner, MemberStatus.added);

      // Initial TaskList
      var taskListRef =
          getTaskListsCollectionRef(projectRef.documentID).document();
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

      // Activity Feed.
      updateActivityFeedToBatch(
        batch: batch,
        projectId: projectRef.documentID,
        type: ActivityFeedEventType.addProject,
        projectName: project.projectName,
        user: store.state.user,
        title: 'created the project ${project.projectName}',
        details: '',
      );

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
      firestoreStreams.projectSubscriptions[projectId].completedTasks =
          subscribeToCompletedTasks(projectId, store, notificationsPlugin);

      // _handleTasksSnapshot will be called for the query and handle everything from here.

    } else {
      await firestoreStreams.projectSubscriptions[projectId]?.completedTasks
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
                  index: getTaskAnimationIndex(preMutationIndices, task.uid),
                  listStateKey: getAnimatedListStateKey(task.taskList),
                  task: task,
                ))
            .toList();

        store.dispatch(ReceiveCompletedTasks(
          originProjectId: projectId,
          tasks: <TaskModel>[],
        ));

        taskAnimationUpdates.sort(TaskAnimationUpdate.removalSorter);
        driveTaskRemovalAnimations(
            taskAnimationUpdates, store.state.memberLookup);
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
      var ref = getTaskListsCollectionRef(projectId).document();
      var taskList = TaskListModel(
        uid: ref.documentID,
        project: projectId,
        taskListName:
            result.value.trim().isEmpty ? 'Untitled List' : result.value.trim(),
        dateAdded: DateTime.now(),
      );

      // Activity Feed.
      updateActivityFeed(
        projectId: projectId,
        type: ActivityFeedEventType.addList,
        projectName: _getProjectName(store.state.projects, projectId),
        user: store.state.user,
        title: 'created the list ${taskList.taskListName}',
        details: '',
      );

      try {
        await ref.setData(taskList.toMap());
      } catch (error) {
        throw error;
      }
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
          getMembersCollectionRef(projectId).document(store.state.user.userId);

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
      await prefs.setString(
          listSortingSharedPreferencesKey, convertTaskListSorting(sorting));
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

    // Activity Feed.
    updateActivityFeed(
      projectId: projectId,
      type: ActivityFeedEventType.moveList,
      projectName: _getProjectName(store.state.projects, projectId),
      user: store.state.user,
      title:
          'Moved the list $listName into ${_getProjectName(store.state.projects, targetProjectId)}',
      details: '',
    );

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
      getTaskListsCollectionRef(sourceProjectId).document(taskListId);

  if (sourceTaskList == null) {
    return;
  }

  TaskListModel targetTaskList =
      sourceTaskList.copyWith(project: targetProjectId);
  var targetTaskListRef =
      getTaskListsCollectionRef(targetProjectId).document(taskListId);

  // Everything Prepped. Let's move.
  var batch = Firestore.instance.batch();

  // Write operations to new Location.
  batch.setData(targetTaskListRef, targetTaskList.toMap());
  for (var task in targetChildTasks) {
    batch.setData(getTasksCollectionRef(targetProjectId).document(task.uid),
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
    sourceTasksRefPath: getTasksCollectionRef(sourceProjectId).path,
    targetTaskListRefPath: targetTaskListRef.path,
    targetTasksRefPath: getTasksCollectionRef(targetProjectId).path,
  ));

  batch.setData(getJobsQueueCollectionRef().document(), cleanupJob.toMap());

  try {
    await batch.commit();
  } catch (error) {
    throw error;
  }
}

ThunkAction<AppState> updateTaskName(String newValue, String oldValue,
    String taskId, String projectId, TaskMetadata existingMetadata) {
  return (Store<AppState> store) async {
    if (newValue?.trim() == oldValue?.trim()) {
      return;
    }

    newValue = newValue.trim();
    var batch = Firestore.instance.batch();
    var ref = getTasksCollectionRef(projectId).document(taskId);
    ArgumentMap argMap;
    bool hasArguments = TaskArgumentParser.hasArguments(newValue);

    if (hasArguments) {
      var parser =
          TaskArgumentParser(projectMembers: store.state.members[projectId]);

      argMap = await parser.parseTextForArguments(newValue);

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

    updateActivityFeedToBatch(
      batch: batch,
      projectId: projectId,
      projectName: _getProjectName(store.state.projects, projectId),
      type: ActivityFeedEventType.editTask,
      user: store.state.user,
      title:
          _buildTaskUpdateActivityFeedTitle(oldValue, newValue, hasArguments),
      details: hasArguments == true && argMap != null
          ? _buildActivityFeedEventTaskDetails(argMap.isHighPriority,
              argMap.dueDate, argMap.assignmentIds, argMap.note, store.state)
          : '',
      assignments: argMap == null || argMap.assignmentIds == null
          ? <Assignment>[]
          : argMap.assignmentIds
              .map((id) =>
                  Assignment.fromMemberModel(store.state.memberLookup[id]))
              .toList(),
    );

    try {
      await batch.commit();
    } catch (error) {
      throw error;
    }
  };
}

String _buildTaskUpdateActivityFeedTitle(
    String oldValue, String newValue, bool hasArguments) {
  final prunedNewValue = TaskArgumentParser.trimArguments(newValue.trim());

  if (hasArguments && oldValue.trim() != prunedNewValue) {
    // Task has had Name and Properties changed.
    return 'updated the properties and renamed the task $oldValue to ${TaskArgumentParser.trimArguments(newValue)}.';
  }

  if (hasArguments && oldValue.trim() == prunedNewValue) {
    // User only updated Properties.
    return 'updated the properties of the task ${truncateString(prunedNewValue, activityFeedTitleTruncationCount)}.';
  }

  if (hasArguments == false && oldValue.trim() != prunedNewValue) {
    // User only updated the Task Name.
    return 'renamed the task $oldValue to $prunedNewValue.';
  }

  return newValue;
}

ThunkAction<AppState> updateTaskListColorWithDialog(
    String taskListId,
    String projectId,
    String taskListName,
    bool hasCustomColor,
    int colorIndex,
    BuildContext context) {
  return (Store<AppState> store) async {
    if (taskListId == null) {
      return;
    }

    var result = await showDialog(
        context: context,
        builder: (context) => TaskListColorSelectDialog(
              colorIndex: colorIndex,
              hasCustomColor: hasCustomColor,
              taskListName: taskListName,
            ));

    if (result is int) {
      var ref = getTaskListsCollectionRef(projectId).document(taskListId);

      // Activity Feed.
      updateActivityFeed(
        projectId: projectId,
        projectName: _getProjectName(store.state.projects, projectId),
        user: store.state.user,
        type: ActivityFeedEventType.reColorList,
        title: 'changed the colour of the list $taskListName',
        details: '',
      );

      try {
        await ref.updateData(
            {'hasCustomColor': result != -1, 'customColorIndex': result});
      } catch (error) {
        throw error;
      }
    }
  };
}

ThunkAction<AppState> addNewTaskWithDialog(
    String projectId, BuildContext context,
    {String taskListId}) {
  return (Store<AppState> store) async {
    var result = await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) => AddTaskDialogContainer(
              destinationTaskListId: taskListId,
              projectId: projectId,
            ));

    if (result == null) {
      return;
    }

    final projectActuallyExists =
        store.state.projects.indexWhere((item) => item.uid == projectId) != -1;

    if (projectActuallyExists == false) {
      showSnackBar(
        targetGlobalKey: homeScreenScaffoldKey,
        message: 'Woops! Sorry that project no longer exists.',
      );
    }

    if (result is AddTaskDialogResult &&
        result.result == DialogResult.affirmative) {
      if (result.isNewTaskList == true) {
        // User has elected to create a new TaskList
        var batch = Firestore.instance.batch();

        // New TaskList
        var taskListRef = getTaskListsCollectionRef(projectId).document();

        var newTaskList = TaskListModel(
          uid: taskListRef.documentID,
          project: projectId,
          taskListName: result.taskListName.trim().isEmpty
              ? 'Untitled List'
              : result.taskListName.trim(),
          dateAdded: DateTime.now(),
        );

        // New Task
        var taskRef = getTasksCollectionRef(projectId).document();
        var taskName = result.taskName.trim().isEmpty
            ? 'Untitled Task'
            : result.taskName.trim();

        var task = TaskModel(
            uid: taskRef.documentID,
            taskList: newTaskList.uid,
            project: projectId,
            userId: store.state.user.userId,
            taskName: taskName,
            dueDate: result.selectedDueDate,
            isHighPriority: result.isHighPriority,
            dateAdded: DateTime.now(),
            assignedTo: result.assignedToIds,
            note: result.note,
            reminders: buildNewRemindersMap(taskRef.documentID, taskName,
                store.state.user.userId, result.reminderTime),
            metadata: TaskMetadata(
              createdBy: store.state.user.displayName,
              createdOn: DateTime.now(),
            ));

        batch.setData(taskRef, task.toMap());
        batch.setData(taskListRef, newTaskList.toMap());

        // Activity Feed.
        updateActivityFeedToBatch(
          batch: batch,
          projectId: projectId,
          projectName: _getProjectName(store.state.projects, projectId),
          type: ActivityFeedEventType.addTask,
          user: store.state.user,
          title:
              'created the list ${newTaskList.taskListName} and added the task ${truncateString(task.taskName, activityFeedTitleTruncationCount)}',
          details: _buildActivityFeedEventTaskDetails(
            task.isHighPriority,
            task.dueDate,
            task.assignedTo,
            task.note,
            store.state,
          ),
          assignments: task.assignedTo
              .map((item) =>
                  Assignment.fromMemberModel(store.state.memberLookup[item]))
              .toList(),
        );

        // Push the new lastUsedTaskListId to state and also persist it on Device storage. So that it can be fetched by the AddNewTaskDialog when triggered from a
        // homescreen shortcut.
        store.dispatch(PushLastUsedTaskList(
          projectId: projectId,
          taskListId: newTaskList.uid,
        ));

        _persistLastUsedTaskLists(mergeLastUsedTaskList(
            store.state.lastUsedTaskLists, projectId, newTaskList.uid));

        try {
          await batch.commit();
        } catch (error) {
          throw error;
        }
      } else {
        // User selected an existing TaskList.
        var batch = Firestore.instance.batch();

        var taskRef = getTasksCollectionRef(projectId).document();
        var targetTaskListId = result.taskListId ??
            taskListId; // Use the taskListId parameter if Dialog returns a null taskListId.
        var taskName = result.taskName.trim().isEmpty
            ? 'Untitled Task'
            : result.taskName.trim();

        var task = TaskModel(
            uid: taskRef.documentID,
            taskList: targetTaskListId,
            userId: store.state.user.userId,
            project: projectId,
            taskName: taskName,
            dueDate: result.selectedDueDate,
            isHighPriority: result.isHighPriority,
            dateAdded: DateTime.now(),
            assignedTo: result.assignedToIds,
            note: result.note,
            reminders: buildNewRemindersMap(taskRef.documentID, taskName,
                store.state.user.userId, result.reminderTime),
            metadata: TaskMetadata(
                createdBy: store.state.user.displayName,
                createdOn: DateTime.now()));

        batch.setData(taskRef, task.toMap());

        // Activity Feed.
        updateActivityFeedToBatch(
          batch: batch,
          projectId: projectId,
          projectName: _getProjectName(store.state.projects, projectId),
          type: ActivityFeedEventType.addTask,
          user: store.state.user,
          title:
              'created the task ${truncateString(task.taskName, activityFeedTitleTruncationCount)}',
          details: _buildActivityFeedEventTaskDetails(
            task.isHighPriority,
            task.dueDate,
            task.assignedTo,
            task.note,
            store.state,
          ),
          assignments: task.assignedTo
              .map((item) =>
                  Assignment.fromMemberModel(store.state.memberLookup[item]))
              .toList(),
        );

        // Push the new lastUsedTaskListId to state and also persist it on Device storage. So that it can be fetched by the AddNewTaskDialog when triggered from a
        // homescreen shortcut.
        store.dispatch(PushLastUsedTaskList(
          projectId: projectId,
          taskListId: targetTaskListId,
        ));

        _persistLastUsedTaskLists(mergeLastUsedTaskList(
            store.state.lastUsedTaskLists, projectId, targetTaskListId));

        try {
          await batch.commit();
        } catch (error) {
          throw error;
        }
      }
    }
  };
}

ThunkAction<AppState> updateFavouriteTaskList(
    String taskListId, String projectId, bool isFavourite) {
  return (Store<AppState> store) async {
    var userId = store.state.user.userId;

    var memberRef = getMembersCollectionRef(projectId).document(userId);

    try {
      await memberRef.updateData({
        'favouriteTaskListId': isFavourite == true ? taskListId : '-1',
      });
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> multiDeleteTasks(
    List<TaskModel> tasks, String projectId, BuildContext context) {
  return (Store<AppState> store) async {
    if (tasks == null || tasks.isEmpty) {
      return;
    }

    var dialogResult = await postConfirmationDialog(
        'Delete Tasks',
        'Are you sure you want to delete ${tasks.length} tasks?',
        'Delete',
        'Cancel',
        context);

    if (dialogResult is DialogResult && dialogResult == DialogResult.negative) {
      return;
    }

    final batch = Firestore.instance.batch();
    final String projectName = _getProjectName(store.state.projects, projectId);
    final List<DocumentReference> activityFeedReferences =
        []; // Collect these to pass to the UndoAction later.

    for (var task in tasks) {
      batch.updateData(getTasksCollectionRef(projectId).document(task.uid),
          {'isDeleted': true});

      // Activity Feed
      activityFeedReferences.add(updateActivityFeedToBatch(
        batch: batch,
        projectId: projectId,
        projectName: projectName,
        type: ActivityFeedEventType.deleteTask,
        user: store.state.user,
        title:
            'deleted the task ${truncateString(task.taskName, activityFeedTitleTruncationCount)}',
        details: '',
      ));
    }

    // Undo Redo.
    var refPaths = tasks
        .map((task) => getTasksCollectionRef(projectId).document(task.uid).path)
        .toList();

    pushUndoAction(
        MultiDeleteTasksUndoActionModel(
          taskRefPaths: refPaths,
          activityFeedReferencePaths:
              activityFeedReferences.map((item) => item.path).toList(),
        ),
        store);

    showSnackBar(
        targetGlobalKey: homeScreenScaffoldKey,
        message:
            'Deleted ${tasks.where((item) => item.isComplete == false).length} task${tasks.length > 1 ? 's' : ''}',
        actionLabel: 'Undo',
        autoHideSeconds: 6,
        onClosed: (reason) {
          if (reason == SnackBarClosedReason.action) {
            undoLastAction(store);
          }
        });

    store.dispatch(SetIsInMultiSelectTaskMode(isInMultiSelectTaskMode: false));

    try {
      await batch.commit();
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> multiAssignTasksWithDialog(
    List<TaskModel> tasks, String projectId, BuildContext context) {
  return (Store<AppState> store) async {
    if (store.state.members[projectId] == null) {
      return;
    }

    final assignmentOptions = store.state.members[projectId]
        .map((member) => Assignment.fromMemberModel(member))
        .toList();

    if (assignmentOptions.isEmpty) {
      return;
    }

    final result = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => ChooseAssignmentDialog(
              initialAssignedOptions: <Assignment>[],
              options: assignmentOptions,
            ));

    store.dispatch(SetIsInMultiSelectTaskMode(isInMultiSelectTaskMode: false));

    if (result == null) {
      return;
    }

    if (result is List<String>) {
      for (var task in tasks) {
        store.dispatch(updateTaskAssignments(
            result, task.uid, task.project, task.taskName, task.metadata));
      }
    }
  };
}

ThunkAction<AppState> multiCompleteTasks(
    List<TaskModel> tasks, String projectId) {
  return (Store<AppState> store) async {
    if (tasks == null || tasks.isEmpty) {
      return;
    }

    // Allow the Task time to Animate it's checkbox before removing it.
    final taskIds = tasks.map((item) => item.uid).toList();
    store.dispatch(AddMultipleCompletingTasks(taskIds: taskIds));
    await Future.delayed(taskCheckboxCompleteAnimationDuration);
    store.dispatch(RemoveMultipleCompletingTasks(taskIds: taskIds));

    final batch = Firestore.instance.batch();
    final projectName = _getProjectName(store.state.projects, projectId);
    final List<DocumentReference> activityFeedReferences =
        []; // Collect these to pass to UndoAction later.

    for (var task in tasks) {
      batch.updateData(getTasksCollectionRef(projectId).document(task.uid),
          {'isComplete': true});
      batch.updateData(getTasksCollectionRef(projectId).document(task.uid), {
        'metadata': _getUpdatedTaskMetadata(task.metadata,
                TaskMetadataUpdateType.completed, store.state.user.displayName)
            .toMap(),
      });

      // Activity Feed.
      activityFeedReferences.add(updateActivityFeedToBatch(
        batch: batch,
        projectId: projectId,
        projectName: projectName,
        type: ActivityFeedEventType.completeTask,
        user: store.state.user,
        title:
            'completed the task ${truncateString(task.taskName, activityFeedTitleTruncationCount)}',
        details: '',
      ));
    }

    // Undo Redo.
    var refPaths = tasks
        .map((task) => getTasksCollectionRef(projectId).document(task.uid).path)
        .toList();

    pushUndoAction(
        MultiCompleteTasksUndoActionModel(
          taskRefPaths: refPaths,
          activityFeedReferencePaths:
              activityFeedReferences.map((item) => item.path).toList(),
        ),
        store);

    showSnackBar(
        targetGlobalKey: homeScreenScaffoldKey,
        message:
            'Completed ${tasks.where((item) => item.isComplete == false).length} task${tasks.length > 1 ? 's' : ''}',
        actionLabel: 'Undo',
        autoHideSeconds: 6,
        onClosed: (reason) {
          if (reason == SnackBarClosedReason.action) {
            undoLastAction(store);
          }
        });

    store.dispatch(SetIsInMultiSelectTaskMode(isInMultiSelectTaskMode: false));

    try {
      await batch.commit();
    } catch (error) {
      throw error;
    }
  };
}

ThunkAction<AppState> updateTaskComplete(String taskId, String projectId,
    String taskName, bool newValue, TaskMetadata existingMetadata) {
  return (Store<AppState> store) async {
    // Allow the Task time to Animate it's checkbox before removing it.
    if (newValue == true) {
      store.dispatch(AddCompletingTask(taskId: taskId));
      await Future.delayed(taskCheckboxCompleteAnimationDuration);
      store.dispatch(RemoveCompletingTask(taskId: taskId));
    }

    final ref =
        getTasksCollectionRef(store.state.selectedProjectId).document(taskId);

    // Activity Feed
    final activityFeedReference = updateActivityFeed(
      projectId: projectId,
      projectName: _getProjectName(store.state.projects, projectId),
      type: newValue == true
          ? ActivityFeedEventType.completeTask
          : ActivityFeedEventType.unCompleteTask,
      user: store.state.user,
      title: newValue == true
          ? 'completed the task ${truncateString(taskName, activityFeedTitleTruncationCount)}'
          : 'undid the task ${truncateString(taskName, activityFeedTitleTruncationCount)}',
      details: '',
    );

    if (newValue == true) {
      // Only allow an Undo if the Task is being completed.
      pushUndoAction(
          CompleteTaskUndoActionModel(
            taskRefPath: ref.path,
            activityFeedReferencePath: activityFeedReference.path,
          ),
          store);
    }

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

ThunkAction<AppState> processChecklists(List<TaskListModel> checklists) {
  return (Store<AppState> store) async {
    for (var taskList in checklists) {
      renewChecklist(taskList,
          _getProjectName(store.state.projects, taskList.project), store);
    }
  };
}

ThunkAction<AppState> persistLastUsedAppTheme(AppThemeModel appTheme) {
  return (Store<AppState> store) async {
    final prefs = await SharedPreferences.getInstance();
    if (appTheme == null) {
      prefs.remove(lastUsedAppThemeSharedPreferencesKey);
    }
    prefs.setString(lastUsedAppThemeSharedPreferencesKey, appTheme.toJSON());
  };
}

ThunkAction<AppState> refreshActivityFeed() {
  return (Store<AppState> store) async {
    _refreshActivityFeed(store.state.selectedActivityFeedProjectId,
        store.state.activityFeedQueryLength, store);

    store.dispatch(SetCanRefreshActivityFeed(canRefresh: false));
  };
}

ThunkAction<AppState> openActivityFeed(
    String projectId, ActivityFeedQueryLength queryLength) {
  return (Store<AppState> store) async {
    // Start the Query.
    _refreshActivityFeed(projectId, queryLength, store);

    // Preset Query Properties.
    store.dispatch(SetActivityFeedQueryLength(length: queryLength));
    store.dispatch(
        SetSelectedActivityFeedProjectId(projectId: projectId ?? '-1'));

    // Open Activity Feed.
    store.dispatch(OpenActivityFeed());
  };
}

void _refreshActivityFeed(String projectId, ActivityFeedQueryLength queryLength,
    Store<AppState> store) async {
  store.dispatch(SetIsRefreshingActivityFeed(isRefreshingActivityFeed: true));

  if (projectId == null || projectId == '-1') {
    // Query for all Projects. Map projectIds into ActivityFeed Queries.
    List<Future<QuerySnapshot>> requests = [];
    requests.addAll(store.state.projectIds.map((id) =>
        getActivityFeedCollectionRef(id.uid)
            .where('timestamp',
                isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()
                    .subtract(parseActivityFeedQueryLength(queryLength))))
            .getDocuments()));

    var snapshots = await Future.wait(requests);

    // Flatten and Map snapshots into ActivityFeedModels
    final events = snapshots.expand((item) => item.documents.map(
        (doc) => ActivityFeedEventModel.fromDoc(doc, store.state.user.userId)));

    // Update state.
    store.dispatch(ReceiveActivityFeed(activityFeed: events.toList()));
    store
        .dispatch(SetIsRefreshingActivityFeed(isRefreshingActivityFeed: false));
  } else {
    // Only query for a single Project.
    final snapshot = await getActivityFeedCollectionRef(projectId)
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()
                .subtract(parseActivityFeedQueryLength(queryLength))))
        .getDocuments();

    store.dispatch(ReceiveActivityFeed(
        activityFeed: snapshot.documents
            .map((doc) =>
                ActivityFeedEventModel.fromDoc(doc, store.state.user.userId))
            .toList()));
    store
        .dispatch(SetIsRefreshingActivityFeed(isRefreshingActivityFeed: false));
  }
}

ThunkAction<AppState> restoreProjectWithDialog(BuildContext context) {
  return (Store<AppState> store) async {
    var currentlyArchivedProjects = store.state.projectIds
        .where((item) => item.isArchived == true)
        .map((item) => ArchivedProjectModel(
            archivedProjectName: item.archivedProjectName,
            uid: item.uid,
            archivedOn: item.archivedOn))
        .toList();

    var result = await showModalBottomSheet(
        context: context,
        builder: (context) => ArchivedProjectsBottomSheet(
              projectOptions: currentlyArchivedProjects,
            ));

    if (result == null) {
      return;
    }

    if (result is String) {
      var projectId = result;
      var ref = getProjectIdsCollectionRef(store.state.user.userId)
          .document(projectId);

      showSnackBar(
        message: 'Project restored',
        autoHideSeconds: 4,
        targetGlobalKey: appSettingsScaffoldKey,
      );

      await ref.updateData({
        'isArchived': false,
        'archivedProjectName': null,
        'archivedOn': null,
      });
    }
  };
}

ThunkAction<AppState> openChecklistSettings(
    TaskListModel taskList, BuildContext context) {
  return (Store<AppState> store) async {
    var currentSettings = taskList.settings.checklistSettings;

    var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ChecklistSettingsDialog(
        renewDate:
            currentSettings.nextRenewDate ?? currentSettings.initialStartDate,
        isChecklist: currentSettings.isChecklist,
        renewInterval: currentSettings.renewInterval,
      ),
    );

    if (result != null && result is ChecklistSettingsDialogResult) {
      if (result.renewNow == true) {
        // Renew Now
        renewChecklist(taskList,
            _getProjectName(store.state.projects, taskList.project), store,
            isManuallyInitiated: true);

        return;
      } else {
        var ref =
            getTaskListsCollectionRef(taskList.project).document(taskList.uid);
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

String _getProjectName(List<ProjectModel> projects, String projectId) {
  // TODO
  // Re implement this to use the ProjectsById lookup.
  var project =
      projects.firstWhere((item) => item.uid == projectId, orElse: () => null);

  if (project == null) {
    return '';
  }

  return project.projectName;
}

String _getTaskListName(List<TaskListModel> taskLists, String taskListId) {
  var taskList = taskLists.firstWhere((item) => item.uid == taskListId,
      orElse: () => null);

  if (taskList == null) {
    return '';
  }

  return taskList.taskListName;
}

String _concatAssignmentsToDisplayNames(
    List<String> assignments, AppState state) {
  if (assignments.length == 1) {
    return ' ${state.memberLookup[assignments[0]]?.displayName ?? ''}';
  }

  if (assignments.length == 2) {
    return ' ${state.memberLookup[assignments[0]]?.displayName ?? ''} and ${state.memberLookup[assignments[1]]?.displayName ?? ''}.';
  } else {
    var string = '';
    for (var id in assignments) {
      if (id != assignments.last) {
        string = string + '${state.memberLookup[id]?.displayName ?? ''}, ';
      } else {
        string = string + 'and ${state.memberLookup[id]?.displayName ?? ''}.';
      }
    }

    return string;
  }
}

String _buildActivityFeedEventTaskDetails(bool isHighPriority, DateTime dueDate,
    List<String> assignedTo, String note, AppState state) {
  final DateFormat formatter = DateFormat.MMMEd();

  final priorityString = isHighPriority == true ? 'Flagged as important. ' : '';
  final dueDateString =
      dueDate == null ? '' : 'Due on ${formatter.format(dueDate)}. ';
  final assignmentsString = assignedTo == null || assignedTo.isEmpty
      ? ''
      : 'Assigned to${_concatAssignmentsToDisplayNames(assignedTo, state)}';
  final detailsString = note == null || note.isEmpty
      ? ''
      : 'Details: ${truncateString(note, 32)}. ';

  return priorityString + dueDateString + assignmentsString + detailsString;
}

void _addProcessingProjectInviteId(String projectId, Store<AppState> store) {
  if (store.state.processingProjectInviteIds.contains(projectId)) {
    return;
  }

  List<String> newList = store.state.processingProjectInviteIds.toList();
  newList.add(projectId);

  store.dispatch(
      SetProcessingProjectInviteIds(processingProjectInviteIds: newList));
}

void _removeProccessingProjectInviteId(
    String projectId, Store<AppState> store) {
  List<String> newList = store.state.processingProjectInviteIds
      .where((item) => item != projectId)
      .toList();

  store.dispatch(
      SetProcessingProjectInviteIds(processingProjectInviteIds: newList));
}

void _persistLastUsedTaskLists(Map<String, String> lastUsedTaskLists) async {
  final prefs = await SharedPreferences.getInstance();
  final jsonEncoder = JsonEncoder();

  await prefs.setString(lastUsedTaskListIdsSharedPreferencesKey,
      jsonEncoder.convert(lastUsedTaskLists ?? <String, String>{}));
}
