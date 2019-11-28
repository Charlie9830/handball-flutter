import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/InheritatedWidgets/EnableStates.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/HomeScreenViewModel.dart';
import 'package:handball_flutter/models/InflatedTaskList.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/presentation/Screens/HomeScreen/HomeScreen.dart';
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
    var projectName = _getProjectName(projectId, store.state.projects);

    return HomeScreenViewModel(
      projectId: projectId,
      projectName: projectName,
      taskListViewModels: _buildTaskListViewModels(store, context),
      onAddNewTaskFabButtonPressed: () => store
          .dispatch(addNewTaskWithDialog(projectId, context, taskListId: null)),
      onAddNewTaskListButtonPressed: () =>
          store.dispatch(addNewTaskListWithDialog(projectId, context)),
      onShareProjectButtonPressed: projectId != '-1'
          ? () => store.dispatch(OpenShareProjectScreen(projectId: projectId))
          : null,
      onSetListSorting: (sorting) =>
          store.dispatch(updateListSorting(projectId, sorting, context)),
      listSorting: store.state.inflatedProject?.taskListSorting ??
          TaskListSorting.dateAdded,
      isInMultiSelectTaskMode: store.state.isInMultiSelectTaskMode,
      onCancelMultiSelectTaskMode: () => store
          .dispatch(SetIsInMultiSelectTaskMode(isInMultiSelectTaskMode: false)),
      onMoveTasksButtonPressed: store.state.multiSelectedTasks.length > 0
          ? () => store.dispatch(moveTasksToListWithDialog(
              store.state.multiSelectedTasks.values.toList(),
              projectId,
              store.state.inflatedProject.inflatedTaskLists
                  .map((item) => item.data)
                  .toList(),
              context))
          : null,
      showOnlySelfTasks: store.state.showOnlySelfTasks,
      onShowOnlySelfTasksChanged: (newValue) =>
          store.dispatch(setShowOnlySelfTasks(newValue)),
      isProjectShared: store.state.members[projectId] != null &&
          store.state.members[projectId].length > 1,
      showCompletedTasks: store.state.showCompletedTasks,
      onShowCompletedTasksChanged: (newValue) =>
          store.dispatch(setShowCompletedTasks(newValue, projectId)),
      onAddNewProjectButtonPressed: () =>
          store.dispatch(addNewProjectWithDialog(context)),
      onLogInHintButtonPress: () =>
          store.dispatch(handleLogInHintButtonPress()),
      onRenameProject: () =>
          store.dispatch(updateProjectName(projectName, projectId, context)),
      onUndoAction: store.state.lastUndoAction == null
          ? null
          : () => store.dispatch(undo()),
      onMultiCompleteTasks: store.state.multiSelectedTasks.length > 0
          ? () => store.dispatch(multiCompleteTasks(
              store.state.multiSelectedTasks.values.toList(), projectId))
          : null,
      onMultiDeleteTasks: store.state.multiSelectedTasks.length > 0
          ? () => store.dispatch(multiDeleteTasks(
              store.state.multiSelectedTasks.values.toList(),
              projectId,
              context))
          : null,
      onDebugButtonPressed: () => store.dispatch(debugButtonPressed()),
      onArchiveProject: () => store.dispatch(
              archiveProjectWithDialog(projectId, projectName, context)),
      onActivityFeedOpen: () => store.dispatch(
        openActivityFeed(projectId, ActivityFeedQueryLength.day)
      )
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
        isAssigned: task.isAssigned,
        assignments: task.getAssignments(store.state.memberLookup),
        onCheckboxChanged: (newValue) => store
            .dispatch(updateTaskComplete(task.uid, task.project, task.taskName, newValue, task.metadata)),
        onDelete: () => store.dispatch(
            deleteTask(task.uid, task.project, task.taskName, context)),
        onMove: () => store.dispatch(moveTasksToListWithDialog(
            <TaskModel>[task],
            task.project,
            store.state.inflatedProject.inflatedTaskLists
                .map((item) => item.data)
                .toList(),
            context)),
        onTap: store.state.isInMultiSelectTaskMode == true
            ? () => _handleTaskMultiSelectChange(
                !store.state.multiSelectedTasks.containsKey(task.uid),
                task,
                store)
            : () => store.dispatch(OpenTaskInspector(taskEntity: task)),
        onLongPress: () => store.dispatch(SetIsInMultiSelectTaskMode(
            isInMultiSelectTaskMode: true, initialSelection: task)),
        isMultiSelected: store.state.multiSelectedTasks.containsKey(task.uid),
        onRadioChanged: (value) =>
            _handleTaskMultiSelectChange(value, task, store),
        isInMultiSelectMode: store.state.isInMultiSelectTaskMode,
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
          isFaviroute: _getIsFavirouteTaskList(taskList, store.state),
          isMenuDisabled: store.state.isInMultiSelectTaskMode,
          childTaskViewModels:
              _buildTaskViewModels(taskList.tasks, store, context),
          isFocused: store.state.focusedTaskListId == taskList.data.uid,
          onTaskListFocus: () => store
              .dispatch(SetFocusedTaskListId(taskListId: taskList.data.uid)),
          onDelete: () => store.dispatch(deleteTaskListWithDialog(
              taskList.data.uid, taskList.data.project, taskList.data.taskListName, context)),
          onRename: () => store.dispatch(renameTaskListWithDialog(
              taskList.data.uid, taskList.data.project, taskList.data.taskListName, context)),
          onAddNewTaskButtonPressed: store.state.isInMultiSelectTaskMode == true
              ? null
              : () => store.dispatch(addNewTaskWithDialog(taskList.data.project, context,
                  taskListId: taskList.data.uid)),
          onSortingChange: (sorting) => store.dispatch(updateTaskSorting(
              taskList.data.project,
              taskList.data.uid,
              taskList.data.settings,
              sorting)),
          onOpenChecklistSettings: () =>
              store.dispatch(openChecklistSettings(taskList.data, context)),
          onMoveToProject: () => store.dispatch(moveTaskListToProjectWithDialog(
              taskList.data.uid,
              taskList.data.project,
              taskList.data.taskListName,
              context)),
          onFaviourteListChange: (isFavourite) => store.dispatch(updateFavouriteTaskList(taskList.data.uid, taskList.data.project, isFavourite)),
          onChooseColor: () => store.dispatch(updateTaskListColorWithDialog(taskList.data.uid, taskList.data.project, taskList.data.taskListName, taskList.data.hasCustomColor, taskList.data.customColorIndex, context)));
    }).toList();
  }

  bool _getIsFavirouteTaskList(InflatedTaskListModel taskList, AppState state) {
    var projectId = taskList.data.project;
    var currentTaskListId = taskList.data.uid;
        if (state.favirouteTaskListIds.containsKey(projectId)) {
        var favirouteTaskListId = state.favirouteTaskListIds[projectId];
      return favirouteTaskListId == currentTaskListId;
    }

    else {
      return false;
    }
  }

  void _handleTaskMultiSelectChange(
      bool value, TaskModel task, Store<AppState> store) {
    if (value == true) {
      store.dispatch(AddMultiSelectedTask(task: task));
    } else {
      store.dispatch(RemoveMultiSelectedTask(task: task));
    }
  }
}
