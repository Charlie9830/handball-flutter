import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/models/Comment.dart';
import 'package:handball_flutter/models/Task.dart';

class TaskInspectorScreenViewModel {
  final TaskModel taskEntity;
  final List<CommentViewModel> commentPreviewViewModels;
  final List<Assignment> assignmentOptions;
  final List<Assignment> assignments;
  final bool isAssignmentInputVisible;
  final dynamic onTaskNameChange;
  final dynamic onIsHighPriorityChange;
  final dynamic onDueDateChange;
  final dynamic onNoteChange;
  final dynamic onClose;
  final dynamic onOpenTaskCommentScreen;
  final dynamic onAssignmentsChange;
  final dynamic onReminderChange;

  TaskInspectorScreenViewModel({
    this.taskEntity,
    this.assignmentOptions,
    this.commentPreviewViewModels,
    this.onTaskNameChange,
    this.isAssignmentInputVisible,
    this.onIsHighPriorityChange,
    this.onDueDateChange,
    this.onNoteChange,
    this.onClose,
    this.onOpenTaskCommentScreen,
    this.assignments,
    this.onAssignmentsChange,
    this.onReminderChange,
  });
}