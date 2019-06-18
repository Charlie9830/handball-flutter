import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/IndicatorGroup.dart';
import 'package:handball_flutter/models/InflatedProject.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/ProjectInvite.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/TextInputDialogModel.dart';
import 'package:handball_flutter/models/User.dart';

class AppState {
  final List<ProjectModel> projects;
  final String selectedProjectId;
  final ProjectModel projectShareMenuEntity;
  final InflatedProjectModel inflatedProject;
  final String selectedTaskId;
  final TaskModel selectedTaskEntity;
  final User user;
  final Map<String, String> lastUsedTaskLists;
  final List<TaskModel> tasks;
  final Map<String, List<TaskModel>> tasksByProject;
  final List<TaskModel> filteredTasks;
  final List<TaskListModel> taskLists;
  final Map<String, List<TaskListModel>> taskListsByProject;
  final List<TaskListModel> filteredTaskLists;
  final Map<String, IndicatorGroup> projectIndicatorGroups;
  final String focusedTaskListId;
  final AccountState accountState;
  final List<ProjectInviteModel> projectInvites;
  final List<String> processingProjectInviteIds;
  final Map<String, List<MemberModel>> members;
  final bool isInvitingUser;
  final List<String> processingMembers;


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
    this.filteredTasks,
    this.taskLists,
    this.taskListsByProject,
    this.filteredTaskLists,
    this.focusedTaskListId,
    this.textInputDialog,
    this.projectIndicatorGroups,
    this.accountState,
    this.projectInvites,
    this.processingProjectInviteIds,
    this.members,
    this.isInvitingUser,
    this.processingMembers,
    });

  AppState copyWith({
    List<ProjectModel> projects,
    Map<String, ProjectType> projectTypeLookup,
    String selectedProjectId,
    ProjectModel projectShareMenuEntity,
    TaskModel selectedTaskEntity,
    User user,
    List<TaskModel> tasks,
    Map<String, List<TaskModel>> tasksByProject,
    List<TaskModel> filteredTasks,
    List<TaskListModel> taskLists,
    Map<String, List<TaskListModel>> taskListsByProject,
    List<TaskListModel> filteredTaskLists,
    String focusedTaskListId,
    TextInputDialogModel textInputDialog,
    Map<String,IndicatorGroup> projectIndicatorGroups,
    InflatedProjectModel inflatedProject,
    Map<String, String> lastUsedTaskLists,
    AccountState accountState,
    List<ProjectInviteModel> projectInvites,
    List<String> processingProjectInviteIds,
    Map<String, List<MemberModel>> members,
    bool isInvitingUser,
    List<String> processingMembers,
  }) {
    return AppState(
      projects: projects ?? this.projects,
      selectedProjectId: selectedProjectId ?? this.selectedProjectId,
      projectShareMenuEntity: projectShareMenuEntity ?? this.projectShareMenuEntity,
      selectedTaskEntity: selectedTaskEntity ?? this.selectedTaskEntity,
      user: user ?? this.user,
      tasks: tasks ?? this.tasks,
      tasksByProject: tasksByProject ?? this.tasksByProject,
      lastUsedTaskLists: lastUsedTaskLists ?? this.lastUsedTaskLists,
      filteredTasks: tasks ?? this.tasks,
      taskLists: taskLists ?? this.taskLists,
      taskListsByProject: taskListsByProject ?? this.taskListsByProject,
      filteredTaskLists: filteredTaskLists ?? this.filteredTaskLists,
      focusedTaskListId: focusedTaskListId ?? this.focusedTaskListId,
      textInputDialog: textInputDialog ?? this.textInputDialog,
      projectIndicatorGroups: projectIndicatorGroups ?? this.projectIndicatorGroups,
      inflatedProject: inflatedProject ?? this.inflatedProject,
      accountState: accountState ?? this.accountState,
      projectInvites: projectInvites ?? this.projectInvites,
      processingProjectInviteIds: processingProjectInviteIds ?? this.processingProjectInviteIds,
      members: members ?? this.members,
      isInvitingUser: isInvitingUser ?? this.isInvitingUser,
      processingMembers: processingMembers ?? this.processingMembers,
    );
  }
}
