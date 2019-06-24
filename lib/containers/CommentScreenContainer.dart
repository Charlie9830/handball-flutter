import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/AppDrawerScreenViewModel.dart';
import 'package:handball_flutter/models/AppSettingsViewModel.dart';
import 'package:handball_flutter/models/Comment.dart';
import 'package:handball_flutter/models/CommentScreenViewModel.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskInspectorScreenViewModel.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AppSettings.dart';
import 'package:handball_flutter/presentation/Screens/CommentScreen.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/TaskInspectorScreen.dart';
import 'package:handball_flutter/redux/actions.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';

class CommentScreenContainer extends StatelessWidget {
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, CommentScreenViewModel>(
      converter: (Store<AppState> store) => _converter(store, context),
      builder: (context, viewModel) {
        return new CommentScreen(viewModel: viewModel);
      },
    );
  }

  _converter(Store<AppState> store, BuildContext context) {
    var projectId = store.state.selectedTaskEntity?.project;
    var taskId = store.state.selectedTaskEntity?.uid;

    return CommentScreenViewModel(
      commentViewModels: _buildCommentViewModels(store, context),
      isGettingComments: store.state.isGettingTaskComments,
      isPaginationComplete: store.state.isTaskCommentPaginationComplete,
      onPaginate: () => store.dispatch(paginateTaskComments(projectId, taskId)),
      onPost: (text) =>
          store.dispatch(postTaskComment(store.state.selectedTaskEntity, text)),
      onClose: () => store.dispatch(closeTaskCommentsScreen(projectId, taskId)),
    );
  }

  List<CommentViewModel> _buildCommentViewModels(
      Store<AppState> store, BuildContext context) {
    return store.state.taskComments.map((comment) {
      return CommentViewModel(
        data: comment,
        isUnread: _isUnread(comment, store.state.user.userId),
        onDelete: _canDelete(comment, store.state.user.userId)
            ? () => store.dispatch(
                deleteTaskComment(store.state.selectedTaskEntity, comment))
            : null,
      );
    }).toList();
  }

  bool _canDelete(CommentModel comment, String userId) {
    return comment.createdBy == userId;
  }

  bool _isUnread(CommentModel comment, String userId) {
    return comment.seenBy.contains(userId) == false;
  }
}
