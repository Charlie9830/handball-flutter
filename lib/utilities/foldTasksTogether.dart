import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/redux/appState.dart';

class FoldedTasks {
  final Map<String, List<TaskModel>> incompletedTasksByProject;
  final Map<String, List<TaskModel>> completedTasksByProject;
  final Map<String, List<TaskModel>> tasksByProject;
  final List<TaskModel> allTasks;

  FoldedTasks({
    this.incompletedTasksByProject,
    this.completedTasksByProject,
    this.tasksByProject,
    this.allTasks,
  });
}

FoldedTasks foldTasksTogether(TasksSnapshotType type,
    List<TaskModel> incomingTasks, String originProjectId, AppState state) {
  if (type == TasksSnapshotType.completed) {
    var completedTasksByProject = _getUpdatedTasksByProject(
      state.completedTasksByProject,
      incomingTasks,
      originProjectId,
    );

    var incompletedTasksByProject = state.incompletedTasksByProject;

    var tasksByProject = _concatTasksByProject(
        state.projects, incompletedTasksByProject, completedTasksByProject);

    var allTasks = tasksByProject.values.expand((i) => i).toList();

    return FoldedTasks(
      allTasks: allTasks,
      completedTasksByProject: completedTasksByProject,
      incompletedTasksByProject: incompletedTasksByProject,
      tasksByProject: tasksByProject,
    );
  } else {
    var incompletedTasksByProject = _getUpdatedTasksByProject(
        state.incompletedTasksByProject, incomingTasks, originProjectId);

    var completedTasksByProject = state.completedTasksByProject;

    var tasksByProject = _concatTasksByProject(
      state.projects,
      incompletedTasksByProject,
      completedTasksByProject,
    );

    var allTasks = tasksByProject.values.expand((i) => i).toList();

    return FoldedTasks(
      allTasks: allTasks,
      completedTasksByProject: completedTasksByProject,
      incompletedTasksByProject: incompletedTasksByProject,
      tasksByProject: tasksByProject,
    );
  }
}

Map<String, List<TaskModel>> _concatTasksByProject(
    List<ProjectModel> projects,
    Map<String, List<TaskModel>> incompletedTasksByProject,
    Map<String, List<TaskModel>> completedTasksByProject) {
  var projectIds = projects.map((item) => item.uid);

  var newMap = <String, List<TaskModel>>{};

  for (var id in projectIds) {
    newMap[id] =
        List<TaskModel>.from(incompletedTasksByProject[id] ?? <TaskModel>[])
          ..addAll(completedTasksByProject[id] ?? <TaskModel>[]);
  }

  return newMap;
}

Map<String, List<TaskModel>> _getUpdatedTasksByProject(
    Map<String, List<TaskModel>> existingTasksByProject,
    List<TaskModel> newTasks,
    String originProjectId) {
  Map<String, List<TaskModel>> newMap = Map.from(existingTasksByProject);
  newMap[originProjectId] = newTasks.toList();

  return newMap;
}
