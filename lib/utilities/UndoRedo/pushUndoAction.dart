import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/UndoActions/DeleteProjectUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/DeleteTaskListUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/DeleteTaskUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/NoAction.dart';
import 'package:handball_flutter/models/UndoActions/UndoAction.dart';
import 'package:handball_flutter/redux/actions.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/utilities/UndoRedo/undoActionSharedPreferencesKey.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

pushUndoAction(UndoActionModel undoAction, Store<AppState> store) async {
  var currentLastUndoAction = store.state.lastUndoAction;
  _executeLastUndoAction(currentLastUndoAction);

  store.dispatch(SetLastUndoAction(lastUndoAction: undoAction));

  try {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(undoActionSharedPreferencesKey, undoAction.toJSON());
  } catch (error) {
    throw error;
  }
}

_executeLastUndoAction(UndoActionModel lastUndoAction) async {
  if (lastUndoAction == null || lastUndoAction is NoAction) {
    // No action required.
    return;
  }

  switch (lastUndoAction.type) {
    case UndoActionType.deleteProject:
      _executeProjectDelete(lastUndoAction);
      break;
    case UndoActionType.deleteTaskList:
      _executeTaskListDelete(lastUndoAction);
      break;
    case UndoActionType.deleteTask:
      _executeDeleteTask(lastUndoAction);
      break;
    case UndoActionType.completeTask:
      // No execute action required.
      break;
    case UndoActionType.multiCompleteTasks:
      // No execute action required.
      break;
    case UndoActionType.moveTask:
      // TODO: Handle this case.
      break;
    case UndoActionType.multiMoveTask:
      // TODO: Handle this case.
      break;
  }

  return;
}

_executeTaskListDelete(DeleteTaskListUndoActionModel undoAction) async {
  var taskListRef = Firestore.instance.document(undoAction.taskListRefPath);
  var childRefs = undoAction.childTaskPaths
      .map((path) => Firestore.instance.document(path));

  var batch = Firestore.instance.batch();

  // Delete children.
  childRefs.forEach((ref) => batch.delete(ref));

  // Delete TaskList.
  batch.delete(taskListRef);

  try {
    await batch.commit();
  } catch (error) {
    throw error;
  }
}

_executeProjectDelete(DeleteProjectUndoActionModel undoAction) async {
  var projectId = undoAction.projectId;
  var userId = undoAction.userId;
  var allMemberIds = undoAction.allMemberIds;
  var otherMemberIds = undoAction.otherMemberIds;
  var taskListIds = undoAction.taskListIds;
  var taskIds = undoAction.taskIds;
  var tasksPath = undoAction.tasksPath;
  var taskListsPath = undoAction.taskListsPath;
  var membersPath = undoAction.membersPath;
  var projectPath = undoAction.projectPath;
  var projectIdPath = undoAction.projectIdPath;

  var batch = Firestore.instance.batch();
  bool isOnlySharedWithSelf =
      allMemberIds.length == 1 && allMemberIds[0] == userId;

  if (isOnlySharedWithSelf) {
    // Project not shared with anyone else. It is safe to remove the user from the Members collection.
    // TODO: Deleting this first, does that cause Firebase Security rules to kick in?
    batch.delete(Firestore.instance.collection(membersPath).document(userId));
  }

  // Build Tasks into Batch
  for (var id in taskIds) {
    batch.delete(Firestore.instance.collection(tasksPath).document(id));
  }

  // Build TaskLists into Batch.
  for (var id in taskListIds) {
    batch.delete(Firestore.instance.collection(taskListsPath).document(id));
  }

  batch.delete(Firestore.instance.document(projectPath));
  batch.delete(Firestore.instance.document(projectIdPath));

  try {
    if (!isOnlySharedWithSelf) {
      // Remove for other Users.
      // var cloudFunctionRequests = otherMemberIds.map((id) =>
      //     _cloudFunctionsLayer.kickUserFromProject(
      //         userId: id, projectId: projectId));
      // await Future.wait(cloudFunctionRequests);

      // TODO: Rework above to use a CleanupRequest so that it can still work even when offline.
    }
    await batch.commit();
    return;
  } catch (error) {
    throw error;
  }
}

_executeDeleteTask(DeleteTaskUndoActionModel undoAction) async {
  var ref = Firestore.instance.document(undoAction.taskRefPath);

  try {
    await ref.delete();
  } catch (error) {
    throw error;
  }
}
