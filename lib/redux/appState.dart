import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/TextInputDialogModel.dart';
import 'package:handball_flutter/models/User.dart';

class AppState {
  final List<ProjectModel> projects;
  final String selectedProjectId;
  final String selectedTaskId;
  final TaskModel selectedTaskEntity;
  final User user;
  final List<TaskModel> tasks;
  final List<TaskModel> filteredTasks;
  final List<TaskListModel> taskLists;
  final List<TaskListModel> filteredTaskLists;
  final String focusedTaskListId;

  final TextInputDialogModel textInputDialog;

  AppState({
    this.projects,
    this.selectedProjectId,
    this.selectedTaskId,
    this.selectedTaskEntity,
    this.user,
    this.tasks,
    this.filteredTasks,
    this.taskLists,
    this.filteredTaskLists,
    this.focusedTaskListId,
    this.textInputDialog,
    });

  AppState copyWith({
    List<ProjectModel> projects,
    List<ProjectModel> localProjects,
    List<ProjectModel> remoteProjects,
    Map<String, ProjectType> projectTypeLookup,
    String selectedProjectId,
    TaskModel selectedTaskEntity,
    User user,
    List<TaskModel> tasks,
    List<TaskModel> filteredTasks,
    List<TaskListModel> taskLists,
    List<TaskListModel> filteredTaskLists,
    String focusedTaskListId,
    TextInputDialogModel textInputDialog
  }) {
    return AppState(
      projects: projects ?? this.projects,
      selectedProjectId: selectedProjectId ?? this.selectedProjectId,
      selectedTaskEntity: selectedTaskEntity ?? this.selectedTaskEntity,
      user: user ?? this.user,
      tasks: tasks ?? this.tasks,
      filteredTasks: tasks ?? this.tasks,
      taskLists: taskLists ?? this.taskLists,
      filteredTaskLists: filteredTaskLists ?? this.filteredTaskLists,
      focusedTaskListId: focusedTaskListId ?? this.focusedTaskListId,
      textInputDialog: textInputDialog ?? this.textInputDialog,
    );
  }
}
