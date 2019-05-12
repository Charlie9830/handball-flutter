import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/ProjectScreenViewModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/presentation/Screens/ProjectScreen.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';
import 'package:handball_flutter/redux/actions.dart';

class ProjectScreenContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, ProjectScreenViewModel> (
      converter: (Store<AppState> store) => _converter(store, context),
      builder: ( context, projectScreenViewModel) {
        return new ProjectScreen(viewModel: projectScreenViewModel);
      }
    );
  }

  ProjectScreenViewModel _converter(Store<AppState> store, BuildContext context) {
    var projectId = store.state.selectedProjectId;
    var taskListId = store.state.focusedTaskListId;

    return ProjectScreenViewModel(
      projectId: projectId,
      projectName: _getProjectName(projectId, store.state.projects),
      taskListViewModels: _buildTaskListViewModels(store, _buildTaskViewModels(store, context), context),
      onAddNewTaskFabButtonPressed: () => store.dispatch(addNewTaskWithDialog(projectId, taskListId, context)),
      onAddNewTaskListFabButtonPressed: () => store.dispatch(addNewTaskListWithDialog(projectId, context)),
    );
  }

  String _getProjectName(String projectId, List<ProjectModel> projects) {
    var project = projects.firstWhere( (item) => item.uid == projectId, 
    orElse: () => null );
    
    return project.projectName ?? '';
  }

  List<TaskViewModel> _buildTaskViewModels(Store<AppState> store, BuildContext context) {
    return store.state.filteredTasks.map( (task) {
      return TaskViewModel(
        data: task,
        onCheckboxChanged: (newValue) => store.dispatch(updateTaskComplete(task.uid, newValue )),
        onSelect: (stumped) {},
        onDelete: () => store.dispatch(deleteTaskWithDialog(task.uid, context)),
        onTaskInspectorOpen: () => store.dispatch(OpenTaskInspector(taskEntity: task)),
      );
    }).toList();
  }

  List<TaskListViewModel> _buildTaskListViewModels(Store<AppState> store, List<TaskViewModel> taskViewModels, BuildContext context) {
    // Builds TaskListModels into TaskListViewModels and store them to a Map.
    var taskListViewModelMap = <String, TaskListViewModel>{};
    store.state.filteredTaskLists.forEach( (taskList) {
      taskListViewModelMap[taskList.uid] = TaskListViewModel(
        data: taskList,
        isFocused: store.state.focusedTaskListId == taskList.uid,
        onTaskListFocus: () => store.dispatch(SetFocusedTaskListId(taskListId: taskList.uid)),
        onDelete: () => store.dispatch(deleteTaskListWithDialog(taskList.uid, taskList.taskListName, context)),
        onRename: () => store.dispatch(renameTaskListWithDialog(taskList.uid, taskList.taskListName, context)),
        onAddNewTaskButtonPressed: () => store.dispatch(addNewTaskWithDialog(taskList.project, taskList.uid, context))
        );
    });

    // Iterate through TaskViewModels and add them to each TaskList in the Map.
    taskViewModels.forEach( (taskViewModel) {
      var taskListId = taskViewModel.data.taskList;
      if (taskListViewModelMap[taskListId] != null) {
        taskListViewModelMap[taskListId].childTaskViewModels.add(taskViewModel);
      }
    });

    // Flatten TaskListViewModel Map into a List.
    return taskListViewModelMap.values.toList();
  }
}

