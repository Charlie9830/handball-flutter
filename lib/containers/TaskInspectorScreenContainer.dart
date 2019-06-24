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
    return new StoreConnector<AppState, TaskInspectorScreenViewModel> (
      converter: (Store<AppState> store) => _converter(store, context),
      builder: ( context, taskInspectorScreenViewModel) {
        return new TaskInspectorScreen(viewModel: taskInspectorScreenViewModel);
      },
    );
  }

  _converter(Store<AppState> store, BuildContext context) {
    return new TaskInspectorScreenViewModel(
      onClose: () => store.dispatch(CloseTaskInspector()),
      taskEntity: store.state.selectedTaskEntity,
      onDueDateChange: (newValue) => store.dispatch(updateTaskDueDate(store.state.selectedTaskEntity.uid, newValue)),
      onNoteChange: (newValue) => store.dispatch(updateTaskNote(newValue, store.state.selectedTaskEntity.uid, store.state.selectedTaskEntity.project)),
      onTaskNameChange: (newValue) => store.dispatch(updateTaskName(newValue, store.state.selectedTaskEntity.uid, store.state.selectedTaskEntity.project)),
      onIsHighPriorityChange: () => store.dispatch(updateTaskPriority(
        !store.state.selectedTaskEntity.isHighPriority,
        store.state.selectedTaskEntity.uid,
        store.state.selectedTaskEntity.project
      )),
      onOpenTaskCommentScreen: () => store.dispatch(openTaskCommentsScreen(store.state.selectedTaskEntity.project, store.state.selectedTaskEntity.uid)),
      commentPreviewViewModels: _buildCommentPreviewViewModels(store.state.selectedTaskEntity?.commentPreview, store.state.user.userId)
    );
  }

  List<CommentViewModel> _buildCommentPreviewViewModels(List<CommentModel> commentPreview, String userId) {
    if (commentPreview == null) {
      return <CommentViewModel>[];
    }

    return commentPreview.map( (item) {
      return CommentViewModel(
        data: item,
        isUnread: item.seenBy.contains(userId) == false,
        onDelete: null,
      );
    }).toList();
  }
}
