import 'package:handball_flutter/models/Task.dart';

class TaskInspectorScreenViewModel {
  final TaskModel taskEntity;
  final dynamic onIsHighPriorityChange;
  final dynamic onDueDateChange;
  final dynamic onDetailsChange;
  final dynamic onClose;

  TaskInspectorScreenViewModel({
    this.taskEntity,
    this.onIsHighPriorityChange,
    this.onDueDateChange,
    this.onDetailsChange,
    this.onClose,
  });
}