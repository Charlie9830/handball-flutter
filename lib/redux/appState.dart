import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/AccountConfig.dart';
import 'package:handball_flutter/models/Comment.dart';
import 'package:handball_flutter/models/EnableState.dart';
import 'package:handball_flutter/models/IndicatorGroup.dart';
import 'package:handball_flutter/models/InflatedProject.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/ProjectInvite.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/TextInputDialogModel.dart';
import 'package:handball_flutter/models/UndoActions/UndoAction.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:quiver/core.dart';

class AppState {
  final List<ProjectModel> projects;
  final String selectedProjectId;
  final ProjectModel projectShareMenuEntity;
  final InflatedProjectModel inflatedProject;
  final String selectedTaskId;
  final TaskModel selectedTaskEntity;
  final UserModel user;
  final Map<String, String> lastUsedTaskLists;
  final List<TaskModel> tasks;
  final Map<String, TaskModel> tasksById;
  final Map<String, List<TaskModel>> tasksByProject;
  final Map<String, List<TaskModel>> completedTasksByProject;
  final Map<String, List<TaskModel>> incompletedTasksByProject;
  final List<TaskListModel> taskLists;
  final Map<String, TaskListModel> deletedTaskLists;
  final Map<String, List<TaskListModel>> taskListsByProject;
  final Map<String, IndicatorGroup> projectIndicatorGroups;
  final String focusedTaskListId;
  final AccountState accountState;
  final List<ProjectInviteModel> projectInvites;
  final List<String> processingProjectInviteIds;
  final Map<String, List<MemberModel>> members;
  final Map<String, MemberModel> memberLookup;
  final bool isInvitingUser;
  final List<String> processingMembers;
  final TaskListSorting listSorting;
  final List<CommentModel> taskComments;
  final bool isTaskCommentPaginationComplete;
  final bool isGettingTaskComments;
  final bool isPaginatingTaskComments;
  final Map<String, TaskModel> multiSelectedTasks;
  final bool isInMultiSelectTaskMode;
  final bool showOnlySelfTasks;
  final bool showCompletedTasks;
  final AccountConfigModel accountConfig;
  final EnableStateModel enableState;
  final UndoActionModel lastUndoAction;

  final TextInputDialogModel textInputDialog;

  AppState({
    this.projects,
    this.selectedProjectId,
    this.projectShareMenuEntity,
    this.inflatedProject,
    this.selectedTaskId,
    this.selectedTaskEntity,
    this.user,
    this.lastUsedTaskLists,
    this.tasks,
    this.tasksByProject,
    this.taskLists,
    this.taskListsByProject,
    this.focusedTaskListId,
    this.textInputDialog,
    this.projectIndicatorGroups,
    this.accountState,
    this.projectInvites,
    this.processingProjectInviteIds,
    this.members,
    this.isInvitingUser,
    this.processingMembers,
    this.listSorting,
    this.taskComments,
    this.isTaskCommentPaginationComplete,
    this.isGettingTaskComments,
    this.isPaginatingTaskComments,
    this.multiSelectedTasks,
    this.isInMultiSelectTaskMode,
    this.memberLookup,
    this.showOnlySelfTasks,
    this.showCompletedTasks,
    this.completedTasksByProject,
    this.incompletedTasksByProject,
    this.accountConfig,
    this.enableState,
    this.lastUndoAction,
    this.tasksById,
    this.deletedTaskLists,
  });

  AppState copyWith({
    List<ProjectModel> projects,
    Map<String, ProjectType> projectTypeLookup,
    String selectedProjectId,
    Optional<ProjectModel> projectShareMenuEntity,
    Optional<TaskModel> selectedTaskEntity,
    UserModel user,
    List<TaskModel> tasks,
    Map<String, List<TaskModel>> tasksByProject,
    List<TaskListModel> taskLists,
    Map<String, List<TaskListModel>> taskListsByProject,
    String focusedTaskListId,
    TextInputDialogModel textInputDialog,
    Map<String, IndicatorGroup> projectIndicatorGroups,
    Optional<InflatedProjectModel> inflatedProject,
    Map<String, String> lastUsedTaskLists,
    AccountState accountState,
    List<ProjectInviteModel> projectInvites,
    List<String> processingProjectInviteIds,
    Map<String, List<MemberModel>> members,
    bool isInvitingUser,
    List<String> processingMembers,
    Map<String, List<String>> customTaskListSorting,
    TaskListSorting listSorting,
    List<CommentModel> taskComments,
    bool isTaskCommentPaginationComplete,
    bool isGettingTaskComments,
    bool isPaginatingTaskComments,
    Map<String, TaskModel> multiSelectedTasks,
    bool isInMultiSelectTaskMode,
    Map<String, MemberModel> memberLookup,
    bool showOnlySelfTasks,
    bool showCompletedTasks,
    Map<String, List<TaskModel>> completedTasksByProject,
    Map<String, List<TaskModel>> incompletedTasksByProject,
    Optional<AccountConfigModel> accountConfig,
    EnableStateModel enableState,
    Optional<UndoActionModel> lastUndoAction,
    Map<String, TaskModel> tasksById,
    Map<String, TaskListModel> deletedTaskLists,
  }) {
    return AppState(
      projects: projects ?? this.projects,
      selectedProjectId: selectedProjectId ?? this.selectedProjectId,
      projectShareMenuEntity: projectShareMenuEntity == null ? this.projectShareMenuEntity : projectShareMenuEntity.orNull,
      selectedTaskEntity: selectedTaskEntity == null ? this.selectedTaskEntity : selectedTaskEntity.orNull,
      user: user ?? this.user,
      tasks: tasks ?? this.tasks,
      tasksByProject: tasksByProject ?? this.tasksByProject,
      lastUsedTaskLists: lastUsedTaskLists ?? this.lastUsedTaskLists,
      taskLists: taskLists ?? this.taskLists,
      taskListsByProject: taskListsByProject ?? this.taskListsByProject,
      focusedTaskListId: focusedTaskListId ?? this.focusedTaskListId,
      textInputDialog: textInputDialog ?? this.textInputDialog,
      projectIndicatorGroups:
          projectIndicatorGroups ?? this.projectIndicatorGroups,
      inflatedProject: inflatedProject == null ? this.inflatedProject : inflatedProject.orNull,
      accountState: accountState ?? this.accountState,
      projectInvites: projectInvites ?? this.projectInvites,
      processingProjectInviteIds:
          processingProjectInviteIds ?? this.processingProjectInviteIds,
      members: members ?? this.members,
      isInvitingUser: isInvitingUser ?? this.isInvitingUser,
      processingMembers: processingMembers ?? this.processingMembers,
      listSorting: listSorting ?? this.listSorting,
      taskComments: taskComments ?? this.taskComments,
      isTaskCommentPaginationComplete: isTaskCommentPaginationComplete ??
          this.isTaskCommentPaginationComplete,
      isGettingTaskComments:
          isGettingTaskComments ?? this.isGettingTaskComments,
      isPaginatingTaskComments:
          isPaginatingTaskComments ?? this.isPaginatingTaskComments,
      multiSelectedTasks: multiSelectedTasks ?? this.multiSelectedTasks,
      isInMultiSelectTaskMode:
          isInMultiSelectTaskMode ?? this.isInMultiSelectTaskMode,
      memberLookup: memberLookup ?? this.memberLookup,
      showOnlySelfTasks: showOnlySelfTasks ?? this.showOnlySelfTasks,
      showCompletedTasks: showCompletedTasks ?? this.showCompletedTasks,
      completedTasksByProject:
          completedTasksByProject ?? this.completedTasksByProject,
      incompletedTasksByProject:
          incompletedTasksByProject ?? this.incompletedTasksByProject,
      accountConfig: accountConfig == null ? this.accountConfig : accountConfig.orNull,
      enableState: enableState ?? this.enableState,
      lastUndoAction: lastUndoAction == null ? this.lastUndoAction : lastUndoAction.orNull,
      tasksById: tasksById ?? this.tasksById,
      deletedTaskLists: deletedTaskLists ?? this.deletedTaskLists,
    );
  }
}
