import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/HomeScreenViewModel.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/presentation/Screens/HomeScreen.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';
import 'package:handball_flutter/redux/actions.dart';

class HomeScreenContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, HomeScreenViewModel>(
        converter: (Store<AppState> store) => _converter(store, context),
        builder: (context, homeScreenViewModel) {
          return new HomeScreen(viewModel: homeScreenViewModel);
        });
  }

  HomeScreenViewModel _converter(Store<AppState> store, BuildContext context) {
    var projectId = store.state.selectedProjectId;

    return HomeScreenViewModel(
      projectId: projectId,
      projectName: _getProjectName(projectId, store.state.projects),
      taskListViewModels: _buildTaskListViewModels(store, context),
      onAddNewTaskFabButtonPressed: () => store
          .dispatch(addNewTaskWithDialog(projectId, context, taskListId: null)),
      onAddNewTaskListFabButtonPressed: () =>
          store.dispatch(addNewTaskListWithDialog(projectId, context)),
      onShareProjectButtonPressed: projectId != '-1'
          ? () => store.dispatch(OpenShareProjectScreen(projectId: projectId))
          : null,
      onSetListSorting: (sorting) =>
          store.dispatch(updateListSorting(projectId, sorting, context)),
      listSorting: store.state.inflatedProject?.taskListSorting ??
          TaskListSorting.dateAdded,
    );
  }

  String _getProjectName(String projectId, List<ProjectModel> projects) {
    var project = projects.firstWhere((item) => item.uid == projectId,
        orElse: () => null);

    return project?.projectName ?? '';
  }

  List<TaskViewModel> _buildTaskViewModels(
      List<TaskModel> tasks, Store<AppState> store, BuildContext context) {
    if (tasks.length == 0) {
      return <TaskViewModel>[];
    }

    return tasks.map((task) {
      return TaskViewModel(
        data: task,
        onCheckboxChanged: (newValue) => store
            .dispatch(updateTaskComplete(task.uid, newValue, task.metadata)),
        onSelect: (stumped) {},
        onDelete: () => store.dispatch(deleteTaskWithDialog(task.uid, context)),
        onMove: () => store.dispatch(moveTasksToListWithDialog(
            <TaskModel>[task],
            task.project,
            store.state.inflatedProject.inflatedTaskLists
                .map((item) => item.data)
                .toList(),
            context)),
        onTaskInspectorOpen: () =>
            store.dispatch(OpenTaskInspector(taskEntity: task)),
      );
    }).toList();
  }

  List<TaskListViewModel> _buildTaskListViewModels(
      Store<AppState> store, BuildContext context) {
    if (store.state.inflatedProject == null) {
      return List<TaskListViewModel>();
    }

    return store.state.inflatedProject.inflatedTaskLists.map((taskList) {
      return TaskListViewModel(
        data: taskList.data,
        childTaskViewModels:
            _buildTaskViewModels(taskList.tasks, store, context),
        isFocused: store.state.focusedTaskListId == taskList.data.uid,
        onTaskListFocus: () =>
            store.dispatch(SetFocusedTaskListId(taskListId: taskList.data.uid)),
        onDelete: () => store.dispatch(deleteTaskListWithDialog(
            taskList.data.uid, taskList.data.taskListName, context)),
        onRename: () => store.dispatch(renameTaskListWithDialog(
            taskList.data.uid, taskList.data.taskListName, context)),
        onAddNewTaskButtonPressed: () => store.dispatch(addNewTaskWithDialog(
            taskList.data.project, context,
            taskListId: taskList.data.uid)),
        onSortingChange: (sorting) => store.dispatch(updateTaskSorting(
            taskList.data.project,
            taskList.data.uid,
            taskList.data.settings,
            sorting)),
        onOpenChecklistSettings: () =>
            store.dispatch(openChecklistSettings(taskList.data, context)),
      );
    }).toList();
  }
}
