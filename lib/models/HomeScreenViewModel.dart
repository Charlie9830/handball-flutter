import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:meta/meta.dart';

class HomeScreenViewModel {
  final String projectId;
  final String projectName;
  final List<TaskListViewModel> taskListViewModels;
  final onAddNewTaskFabButtonPressed;
  final onAddNewTaskListFabButtonPressed;

  HomeScreenViewModel({
    this.projectId,
    this.projectName,
    this.taskListViewModels,
    this.onAddNewTaskFabButtonPressed,
    this.onAddNewTaskListFabButtonPressed,
    });
}