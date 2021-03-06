import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/TaskList.dart';

class HomeScreenViewModel {
  final String projectId;
  final String projectName;
  final List<TaskListViewModel> taskListViewModels;
  final TaskListSorting listSorting;
  final bool showCompletedTasks;
  final bool isInMultiSelectTaskMode;
  final bool showOnlySelfTasks;
  final dynamic onShowOnlySelfTasksChanged;
  final onAddNewTaskFabButtonPressed;
  final onAddNewTaskListButtonPressed;
  final onShareProjectButtonPressed;
  final onSetListSorting;
  final bool isProjectShared;
  final dynamic onUndoAction;
  final dynamic onCancelMultiSelectTaskMode;
  final dynamic onMoveTasksButtonPressed;
  final dynamic onShowCompletedTasksChanged;
  final dynamic onAddNewProjectButtonPressed;
  final dynamic onLogInHintButtonPress;
  final dynamic onRenameProject;
  final dynamic onMultiCompleteTasks;
  final dynamic onMultiDeleteTasks;
  final dynamic onDebugButtonPressed;
  final dynamic onArchiveProject;
  final dynamic onActivityFeedOpen;
  final dynamic onMultiAssignTasks;

  HomeScreenViewModel({
    this.projectId,
    this.projectName,
    this.taskListViewModels,
    this.isInMultiSelectTaskMode,
    this.onAddNewTaskFabButtonPressed,
    this.onAddNewTaskListButtonPressed,
    this.onShareProjectButtonPressed,
    this.onSetListSorting,
    this.listSorting,
    this.onCancelMultiSelectTaskMode,
    this.onMoveTasksButtonPressed,
    this.showOnlySelfTasks,
    this.onShowOnlySelfTasksChanged,
    this.isProjectShared,
    this.onShowCompletedTasksChanged,
    this.showCompletedTasks,
    this.onAddNewProjectButtonPressed,
    this.onLogInHintButtonPress,
    this.onRenameProject,
    this.onUndoAction,
    this.onMultiCompleteTasks,
    this.onMultiDeleteTasks,
    this.onDebugButtonPressed,
    this.onArchiveProject,
    this.onActivityFeedOpen,
    this.onMultiAssignTasks,
    });
}