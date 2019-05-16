import 'package:handball_flutter/models/InflatedProject.dart';
import 'package:handball_flutter/models/InflatedTaskList.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/utilities/getProjectIndicatorGroups.dart';

import '../enums.dart';
import './appState.dart';
import './actions.dart';

AppState appReducer(AppState state, dynamic action ) {
  if (action is SelectProject) {
    var filteredTasks = _filterTasks( action.uid, state.tasks);
    var filteredTaskLists = _filterTaskLists(action.uid, state.taskLists);

    return state.copyWith(
      selectedProjectId: action.uid,
      inflatedProject: _buildInflatedProject(
        filteredTasks,
        filteredTaskLists,
        state.projects.firstWhere((item) => item.uid == action.uid, orElse: () => null)),
      filteredTasks: filteredTasks,
      filteredTaskLists: filteredTaskLists,
    );
  }

  if (action is SetUser) {
    return state.copyWith(
      user: action.user,
    );
  }

  if (action is ReceiveLocalProjects) {
    return state.copyWith(projects: action.projects);
  }

  if (action is ReceiveLocalTasks) {
    var filteredTasks = _filterTasks( state.selectedProjectId, action.tasks);

    return state.copyWith(
      tasks: action.tasks,
      filteredTasks: filteredTasks,
      selectedTaskEntity: _updateSelectedTaskEntity(state.selectedTaskEntity, action.tasks),
      projectIndicatorGroups: getProjectIndicatorGroups(action.tasks),
      inflatedProject: _buildInflatedProject(
        filteredTasks,
        state.filteredTaskLists,
        state.projects.firstWhere((item) => item.uid == state.selectedProjectId, orElse: () => null)),
      );
  }

  if (action is ReceiveLocalTaskLists) {
    var filteredTaskLists = _filterTaskLists(state.selectedProjectId, action.taskLists);

    return state.copyWith(
      taskLists: action.taskLists,
      filteredTaskLists: filteredTaskLists,
      inflatedProject: _buildInflatedProject(
        state.filteredTasks,
        filteredTaskLists,
        state.projects.firstWhere((item) => item.uid == state.selectedProjectId, orElse: () => null)),
    );
  }

  if (action is SetFocusedTaskListId) {
    return state.copyWith(
      focusedTaskListId: action.taskListId,
    );
  }

  if (action is SetTextInputDialog) {
    return state.copyWith(
      textInputDialog: action.dialog
    );
  }

  if (action is SetSelectedTaskEntity) {
    return state.copyWith(
      selectedTaskEntity: action.taskEntity
    );
  }

  return state;
}

  _filterTaskLists(String projectId, List<TaskListModel> taskLists) {
        return taskLists.where( (taskList) => taskList.project == projectId).toList();
  }

  _filterTasks(String projectId, List<TaskModel> tasks) {
      return tasks.where( (task) => task.project == projectId).toList();
  }

TaskModel _updateSelectedTaskEntity(TaskModel originalEntity, List<TaskModel> tasks) {
  if (originalEntity == null) {
    // No need to update.
    return null;
  }

  return tasks.firstWhere(
    (task) => task.uid == originalEntity.uid,
    orElse: () => null);
}


InflatedProjectModel _buildInflatedProject(List<TaskModel> tasks, List<TaskListModel> taskLists, ProjectModel project) {
  if (project == null) {
    return null;
  }

  var inflatedTaskLists = taskLists.where( (taskList) => taskList.project == project.uid).map( (taskList) {
    return InflatedTaskListModel(
      data: taskList,
      tasks: _sortTasks(tasks.where( (task) => task.taskList == taskList.uid).toList(), TaskSorting.alphabetically ),
    );
  }).toList();

  return InflatedProjectModel(
    data: project,
    inflatedTaskLists: inflatedTaskLists,
    taskIndices: _buildTaskIndices(inflatedTaskLists)
  );
}

Map<String, int> _buildTaskIndices(List<InflatedTaskListModel> inflatedTaskListModels) {
  var map = Map<String, int>();
  for (var taskList in inflatedTaskListModels) {
    int index = 0;
    for (var task in taskList.tasks) {
      map[task.uid] = index++;
    }
  }

  return map;
}

List<TaskModel> _sortTasks(List<TaskModel> tasks, TaskSorting sorting) {
  return tasks;
}