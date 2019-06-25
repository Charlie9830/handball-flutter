import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/models/AppDrawerScreenViewModel.dart';
import 'package:handball_flutter/models/Comment.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/TaskInspectorScreenViewModel.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/TaskInspectorScreen.dart';
import 'package:handball_flutter/redux/actions.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';

class TaskInspectorScreenContainer extends StatelessWidget {
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, TaskInspectorScreenViewModel>(
      converter: (Store<AppState> store) => _converter(store, context),
      builder: (context, taskInspectorScreenViewModel) {
        return new TaskInspectorScreen(viewModel: taskInspectorScreenViewModel);
      },
    );
  }

  _converter(Store<AppState> store, BuildContext context) {
    var selectedTaskEntity = store.state.selectedTaskEntity;

    return new TaskInspectorScreenViewModel(
        onClose: () => store.dispatch(CloseTaskInspector()),
        taskEntity: selectedTaskEntity,
        onDueDateChange: (newValue) => store.dispatch(
            updateTaskDueDate(selectedTaskEntity.uid, newValue, selectedTaskEntity.dueDate, selectedTaskEntity.metadata)),
        onNoteChange: (newValue) => store.dispatch(updateTaskNote(
            newValue,
            selectedTaskEntity.note,
            selectedTaskEntity.uid,
            selectedTaskEntity.project,
            selectedTaskEntity.metadata)),
        onTaskNameChange: (newValue) => store.dispatch(updateTaskName(
            newValue,
            selectedTaskEntity.taskName,
            selectedTaskEntity.uid,
            selectedTaskEntity.project,
            selectedTaskEntity.metadata)),
        onIsHighPriorityChange: () => store.dispatch(updateTaskPriority(
            !selectedTaskEntity.isHighPriority,
            selectedTaskEntity.uid,
            selectedTaskEntity.project,
            selectedTaskEntity.metadata)),
        onOpenTaskCommentScreen: () => store.dispatch(openTaskCommentsScreen(
            selectedTaskEntity.project,
            selectedTaskEntity.uid)),
        commentPreviewViewModels: _buildCommentPreviewViewModels(
            selectedTaskEntity?.commentPreview,
            store.state.user.userId));
  }

  List<CommentViewModel> _buildCommentPreviewViewModels(
      List<CommentModel> commentPreview, String userId) {
    if (commentPreview == null) {
      return <CommentViewModel>[];
    }

    return commentPreview.map((item) {
      return CommentViewModel(
        data: item,
        isUnread: item.seenBy.contains(userId) == false,
        onDelete: null,
      );
    }).toList();
  }
}
