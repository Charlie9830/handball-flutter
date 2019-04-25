import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';

import './appState.dart';
import './actions.dart';

AppState appReducer(AppState state, dynamic action ) {
  if (action is SelectProject) {
    return state.copyWith(
      selectedProjectId: action.uid,
      filteredTasks: _filterTasks( state.selectedProjectId, state.tasks),
      filteredTaskLists: _filterTaskLists(state.selectedProjectId, state.taskLists)
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
    return state.copyWith(
      tasks: action.tasks,
      filteredTasks: _filterTasks( state.selectedProjectId, action.tasks)
      );
  }

  if (action is ReceiveLocalTaskLists) {
    return state.copyWith(
      taskLists: action.taskLists,
      filteredTaskLists: _filterTaskLists(state.selectedProjectId, action.taskLists)
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