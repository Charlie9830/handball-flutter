import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/enums.dart';
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
      taskListViewModels: _buildTaskListViewModels(store, context),
      onAddNewTaskFabButtonPressed: () => store.dispatch(addNewTaskWithDialog(projectId, taskListId, context)),
      onAddNewTaskListFabButtonPressed: () => store.dispatch(addNewTaskListWithDialog(projectId, context)),
    );
  }

  String _getProjectName(String projectId, List<ProjectModel> projects) {
    var project = projects.firstWhere( (item) => item.uid == projectId, 
    orElse: () => null );
    
    return project.projectName ?? '';
  }

  List<TaskViewModel> _buildTaskViewModels(List<TaskModel> tasks, Store<AppState> store, BuildContext context) {
    return tasks.map( (task) {
      return TaskViewModel(
        data: task,
        onCheckboxChanged: (newValue) => store.dispatch(updateTaskComplete(task.uid, newValue )),
        onSelect: (stumped) {},
        onDelete: () => store.dispatch(deleteTaskWithDialog(task.uid, context)),
        onTaskInspectorOpen: () => store.dispatch(OpenTaskInspector(taskEntity: task)),
      );
    }).toList();
  }

  List<TaskListViewModel> _buildTaskListViewModels(Store<AppState> store, BuildContext context) {
    if (store.state.inflatedProject == null) {
      return List<TaskListViewModel>();
    }

    return store.state.inflatedProject.inflatedTaskLists.map( (taskList) {
      return TaskListViewModel(
        data: taskList.data,
        childTaskViewModels: _buildTaskViewModels(taskList.tasks, store, context),
        isFocused: store.state.focusedTaskListId == taskList.data.uid,
        onTaskListFocus: () => store.dispatch(SetFocusedTaskListId(taskListId: taskList.data.uid)),
        onDelete: () => store.dispatch(deleteTaskListWithDialog(taskList.data.uid, taskList.data.taskListName, context)),
        onRename: () => store.dispatch(renameTaskListWithDialog(taskList.data.uid, taskList.data.taskListName, context)),
        onAddNewTaskButtonPressed: () => store.dispatch(addNewTaskWithDialog(taskList.data.project, taskList.data.uid, context)),
        onSortingChange: (sorting) => store.dispatch(updateTaskSorting(taskList.data.project, taskList.data.uid, taskList.data.settings, sorting)),
      );
    }).toList();
  }
}

