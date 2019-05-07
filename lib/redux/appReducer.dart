import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';

import './appState.dart';
import './actions.dart';

AppState appReducer(AppState state, dynamic action ) {
  if (action is SelectProject) {
    return state.copyWith(
      selectedProjectId: action.uid,
      filteredTasks: _filterTasks( action.uid, state.tasks),
      filteredTaskLists: _filterTaskLists(action.uid, state.taskLists)
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
      filteredTasks: _filterTasks( state.selectedProjectId, action.tasks),
      selectedTaskEntity: _updateSelectedTaskEntity(state.selectedTaskEntity, action.tasks)
      );
  }

  if (action is ReceiveLocalTaskLists) {
    return state.copyWith(
      taskLists: action.taskLists,
      filteredTaskLists: _filterTaskLists(state.selectedProjectId, action.taskLists)
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