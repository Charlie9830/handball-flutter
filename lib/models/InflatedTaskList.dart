import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';

class InflatedTaskListModel {
  TaskListModel data;
  List<TaskModel> tasks;

  InflatedTaskListModel({
    this.data,
    this.tasks
  });
}
