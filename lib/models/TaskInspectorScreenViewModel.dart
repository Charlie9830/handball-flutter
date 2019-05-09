import 'package:handball_flutter/models/Task.dart';

class TaskInspectorScreenViewModel {
  final TaskModel taskEntity;
  final dynamic onTaskNameChange;
  final dynamic onIsHighPriorityChange;
  final dynamic onDueDateChange;
  final dynamic onNoteChange;
  final dynamic onClose;

  TaskInspectorScreenViewModel({
    this.taskEntity,
    this.onTaskNameChange,
    this.onIsHighPriorityChange,
    this.onDueDateChange,
    this.onNoteChange,
    this.onClose,
  });
}