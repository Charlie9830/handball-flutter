import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/models/Comment.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskInspectorScreenViewModel.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/TaskInspectorScreen.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/redux/asyncActions.dart';
import 'package:handball_flutter/redux/syncActions.dart';
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
        assignmentInputType:
            _getAssignmentInputType(store, selectedTaskEntity),
        assignments:
            selectedTaskEntity.getAssignments(store.state.memberLookup),
        assignmentOptions: _getAssignmentOptions(
            store.state.members[selectedTaskEntity.project]),
        onDueDateChange: (newValue) => store.dispatch(updateTaskDueDate(
            selectedTaskEntity.uid,
            selectedTaskEntity.project,
            newValue,
            selectedTaskEntity.dueDate,
            selectedTaskEntity.taskName,
            selectedTaskEntity.metadata)),
        onNoteChange: (newValue) => store.dispatch(updateTaskNote(
            newValue,
            selectedTaskEntity.note,
            selectedTaskEntity.uid,
            selectedTaskEntity.project,
            selectedTaskEntity.taskName,
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
            selectedTaskEntity.taskName,
            selectedTaskEntity.metadata)),
        onOpenTaskCommentScreen: () => store
            .dispatch(openTaskCommentsScreen(selectedTaskEntity.project, selectedTaskEntity.uid)),
        commentPreviewViewModels: _buildCommentPreviewViewModels(selectedTaskEntity?.commentPreview, store.state.user.userId),
        onAssignmentsChange: (newAssignmentIds) => store.dispatch(updateTaskAssignments(newAssignmentIds, selectedTaskEntity.uid, selectedTaskEntity.project, selectedTaskEntity.taskName, selectedTaskEntity.metadata)),
        onReminderChange: (newValue) => store.dispatch(updateTaskReminder(newValue, selectedTaskEntity.ownReminder?.time, selectedTaskEntity.uid, selectedTaskEntity.taskName, selectedTaskEntity.project)));
  }

  TaskInspectorAssignmentInputType _getAssignmentInputType(
      Store<AppState> store, TaskModel selectedTaskEntity) {
    // It is possible, that if all but one user leaves a project, that user can then get stuck with assignments on Tasks that they can't remove. So we
    // have three possible states that dicate if and how the Assignment Input is displayed.
    // Normal - Is displayed as normal
    // Hidden - Is hidden as the user can't make any viable assignments
    // ClearOnly - Allows for clearing only. So the user can clear assignments left behind by members now gone.

    final members = store.state.members[selectedTaskEntity.project];
    final currentAssignmentCount = selectedTaskEntity.assignedTo.length;

    if (members.length > 1) {
      return TaskInspectorAssignmentInputType.normal;
    }

    if (members.length == 1 && currentAssignmentCount > 0) {
      return TaskInspectorAssignmentInputType.clearOnly;
    }

    else {
      return TaskInspectorAssignmentInputType.hidden;
    }
  }

  List<Assignment> _getAssignmentOptions(List<MemberModel> projectMembers) {
    if (projectMembers == null) {
      return <Assignment>[];
    }

    return projectMembers
        .map((item) => Assignment(
              displayName: item.displayName,
              userId: item.userId,
            ))
        .toList();
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
