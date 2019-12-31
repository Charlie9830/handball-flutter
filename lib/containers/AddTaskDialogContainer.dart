import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/models/ActivityFeedViewModel.dart';
import 'package:handball_flutter/models/AddNewTaskDialogViewModel.dart';
import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/presentation/Dialogs/AddTaskDialog/AddTaskDialog.dart';
import 'package:handball_flutter/presentation/Screens/ActivityFeed/ActivityFeed.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/redux/asyncActions.dart';
import 'package:handball_flutter/redux/syncActions.dart';
import 'package:redux/redux.dart';

class AddTaskDialogContainer extends StatelessWidget {
  final String destinationTaskListId;
  final String projectId;

  AddTaskDialogContainer({
    @required this.destinationTaskListId,
    @required this.projectId,
  });

  Widget build(BuildContext context) {
    return new StoreConnector<AppState, AddNewTaskDialogViewModel>(
      converter: (Store<AppState> store) => _converter(store, context),
      builder: (context, viewModel) {
        return AddTaskDialog(
          preselectedTaskList: viewModel.preSelectedTaskList,
          taskLists: viewModel.taskLists,
          favirouteTaskListId: viewModel.favirouteTaskListId,
          allowTaskListChange: destinationTaskListId == null,
          assignmentOptions: viewModel.assignmentOptions,
          memberLookup: viewModel.memberLookup,
          isProjectShared: viewModel.isProjectShared,
        );
      },
    );
  }

  _converter(Store<AppState> store, BuildContext context) {
    return new AddNewTaskDialogViewModel(
      preSelectedTaskList: _getAddTaskDialogPreselectedTaskList(
          projectId,
          destinationTaskListId,
          store.state.taskListsByProject[projectId],
          store.state),
      taskLists: store.state.taskListsByProject[projectId] ?? <TaskListModel>[],
      favirouteTaskListId: store.state.favirouteTaskListIds[projectId] ?? '-1',
      assignmentOptions: _getAssignmentOptions(projectId, store.state),
      isProjectShared: store.state.members[projectId] != null &&
              store.state.members[projectId].length > 1,
      memberLookup: store.state.memberLookup ?? <String, MemberModel>{},
    );
  }
}

List<Assignment> _getAssignmentOptions(String projectId, AppState state) {
  return state.members[projectId] == null
      ? <Assignment>[]
      : state.members[projectId]
          .map((item) =>
              Assignment(userId: item.userId, displayName: item.displayName))
          .toList();
}

TaskListModel _getAddTaskDialogPreselectedTaskList(String projectId,
    String taskListId, List<TaskListModel> taskLists, AppState state) {
  // Try to retreive a Tasklist to become the Preselected List for the AddTaskDialog.
  // Honor these rules in order.
  // 1. Try and retrieve Tasklist directly using provided taskListId (if provided). This indicates the user has
  //  used the TaskList addTask button instead of the Fab.
  // 2. Try and retreive using the Users elected Faviroute Task List.
  // 3. Try and retreive using the lastUsedTaskLists Map. (Most recent addition).
  // 4. Check if only one TaskList is available.

  // First try and retrieve directly.
  if (taskListId != null && taskListId != '-1') {
    var extractedTaskList = state.taskListsByProject[projectId]
        .firstWhere((item) => item.uid == taskListId, orElse: () => null);
    if (extractedTaskList != null) {
      return extractedTaskList;
    }
  }

  // Nothing? Try FavirouteTaskListId.
  if (state.favirouteTaskListIds.containsKey(projectId)) {
    var favirouteTaskListId = state.favirouteTaskListIds[projectId];
    var faviorouteTaskList = taskLists.firstWhere(
        (item) => item.uid == favirouteTaskListId,
        orElse: () => null);

    if (faviorouteTaskList != null) {
      return faviorouteTaskList;
    }
  }

  // Retreiving directly failed, probably because no taskListId was provided to begin with.
  // So now try and retrieve from lastUsedTaskLists.
  var lastUsedTaskListId = state.lastUsedTaskLists[projectId];
  if (lastUsedTaskListId != null) {
    var extractedTaskList = state.taskListsByProject[projectId].firstWhere(
        (item) => item.uid == lastUsedTaskListId,
        orElse: () => null);

    if (extractedTaskList != null) {
      return extractedTaskList;
    }
  }

  if (state.taskListsByProject[projectId] != null && state.taskListsByProject[projectId].length == 1) {
    return state.taskListsByProject[projectId].first;
  }

  // Everything has Failed. TaskList could not be retrieved.
  return null;
}
