import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:meta/meta.dart';

class HomeScreenViewModel {
  final String projectId;
  final String projectName;
  final List<TaskListViewModel> taskListViewModels;
  final TaskListSorting listSorting;
  final onAddNewTaskFabButtonPressed;
  final onAddNewTaskListFabButtonPressed;
  final onShareProjectButtonPressed;
  final onSetListSorting;

  HomeScreenViewModel({
    this.projectId,
    this.projectName,
    this.taskListViewModels,
    this.onAddNewTaskFabButtonPressed,
    this.onAddNewTaskListFabButtonPressed,
    this.onShareProjectButtonPressed,
    this.onSetListSorting,
    this.listSorting,
    });
}