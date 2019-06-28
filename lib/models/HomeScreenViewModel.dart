import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:meta/meta.dart';

class HomeScreenViewModel {
  final String projectId;
  final String projectName;
  final List<TaskListViewModel> taskListViewModels;
  final TaskListSorting listSorting;
  final bool isInMultiSelectTaskMode;
  final bool showOnlySelfTasks;
  final dynamic onShowOnlySelfTasksChanged;
  final onAddNewTaskFabButtonPressed;
  final onAddNewTaskListFabButtonPressed;
  final onShareProjectButtonPressed;
  final onSetListSorting;
  final bool isProjectShared;
  final dynamic onCancelMultiSelectTaskMode;
  final dynamic onMoveTasksButtonPressed;

  HomeScreenViewModel({
    this.projectId,
    this.projectName,
    this.taskListViewModels,
    this.isInMultiSelectTaskMode,
    this.onAddNewTaskFabButtonPressed,
    this.onAddNewTaskListFabButtonPressed,
    this.onShareProjectButtonPressed,
    this.onSetListSorting,
    this.listSorting,
    this.onCancelMultiSelectTaskMode,
    this.onMoveTasksButtonPressed,
    this.showOnlySelfTasks,
    this.onShowOnlySelfTasksChanged,
    this.isProjectShared,
    });
}