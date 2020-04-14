import 'package:flutter/foundation.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/AccountConfig.dart';
import 'package:handball_flutter/models/ActivityFeedEventModel.dart';
import 'package:handball_flutter/models/Comment.dart';
import 'package:handball_flutter/models/InflatedProject.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/ProjectIdModel.dart';
import 'package:handball_flutter/models/ProjectInvite.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/TextInputDialogModel.dart';
import 'package:handball_flutter/models/UndoActions/UndoAction.dart';
import 'package:handball_flutter/models/User.dart';

class OpenAppSettings {
  final AppSettingsTabs tab;

  OpenAppSettings({
    this.tab,
  });
}

class OpenActivityFeed {}

class CloseActivityFeed {}

class InjectDisplayName {
  final String displayName;

  InjectDisplayName({
    this.displayName,
  });
}

class UpdateDisplayName {
  final String newDisplayName;

  UpdateDisplayName({this.newDisplayName});
}

class SetSplashScreenState {
  final SplashScreenState state;

  SetSplashScreenState({
    this.state,
  });
}

class SetLinkingCode {
  final String linkingCode;

  SetLinkingCode({
    this.linkingCode,
  });
}

class ReceiveAccountConfig {
  final AccountConfigModel accountConfig;

  ReceiveAccountConfig({
    this.accountConfig,
  });
}

class SetActivityFeedQueryLength {
  final ActivityFeedQueryLength length;
  final bool isUserInitiated;

  SetActivityFeedQueryLength({
    this.length,
    this.isUserInitiated,
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

class ReceiveProjectIds {
  final List<ProjectIdModel> projectIds;

  ReceiveProjectIds({this.projectIds});
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

class ReceiveDeletedTaskLists {
  final List<TaskListModel> taskLists;
  final String originProjectId;

  ReceiveDeletedTaskLists({
    this.taskLists,
    this.originProjectId,
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
  final UserModel user;

  SignIn({this.user});
}

class SetCanRefreshActivityFeed {
  final bool canRefresh;

  SetCanRefreshActivityFeed({this.canRefresh});
}

class ReceiveMembers {
  final String projectId;
  final List<MemberModel> membersList;

  ReceiveMembers({
    this.projectId,
    this.membersList,
  });
}

class ReceiveActivityFeed {
  final List<ActivityFeedEventModel> activityFeed;

  ReceiveActivityFeed({
    this.activityFeed,
  });
}

class SetSelectedActivityFeedProjectId {
  final String projectId;
  final bool isUserInitiated;

  SetSelectedActivityFeedProjectId({
    this.projectId,
    this.isUserInitiated,
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

class SetLastUsedTaskLists {
  final Map<String, String> value;

  SetLastUsedTaskLists({this.value});
}

class OpenShareProjectScreen {
  final String projectId;

  OpenShareProjectScreen({this.projectId});
}

class SetIsRefreshingActivityFeed {
  final bool isRefreshingActivityFeed;

  SetIsRefreshingActivityFeed({
    this.isRefreshingActivityFeed,
  });
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
  final bool isInitializing;

  SetLastUndoAction({
    this.lastUndoAction,
    this.isInitializing,
  });
}
