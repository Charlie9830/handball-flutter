import 'package:handball_flutter/models/Task.dart';
import 'package:meta/meta.dart';

class TaskListModel {
  String uid;
  String project;
  String taskListName;

  TaskListModel({this.uid, this.project, this.taskListName}); 
}

class TaskListViewModel {

  TaskListModel data;
  List<TaskViewModel> childTaskViewModels = [];
  bool isFocused;

  final onTaskListFocus;

  TaskListViewModel({
    this.data,
    this.onTaskListFocus,
    this.isFocused,
    });
}