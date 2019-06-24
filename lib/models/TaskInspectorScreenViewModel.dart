import 'package:handball_flutter/models/Comment.dart';
import 'package:handball_flutter/models/Task.dart';

class TaskInspectorScreenViewModel {
  final TaskModel taskEntity;
  final List<CommentViewModel> commentPreviewViewModels;
  final dynamic onTaskNameChange;
  final dynamic onIsHighPriorityChange;
  final dynamic onDueDateChange;
  final dynamic onNoteChange;
  final dynamic onClose;
  final dynamic onOpenTaskCommentScreen;

  TaskInspectorScreenViewModel({
    this.taskEntity,
    this.commentPreviewViewModels,
    this.onTaskNameChange,
    this.onIsHighPriorityChange,
    this.onDueDateChange,
    this.onNoteChange,
    this.onClose,
    this.onOpenTaskCommentScreen,
  });
}