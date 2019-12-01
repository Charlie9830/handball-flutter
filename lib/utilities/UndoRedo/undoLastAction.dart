import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/UndoActions/DeleteProjectUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/DeleteTaskListUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/DeleteTaskUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/CompleteTaskUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/MultiCompleteTasksUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/MultiDeleteTasksUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/NoAction.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/redux/syncActions.dart';
import 'package:handball_flutter/utilities/UndoRedo/undoActionSharedPreferencesKey.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

undoLastAction(Store<AppState> store) async {
  var lastUndoAction = store.state.lastUndoAction;

  if (lastUndoAction == null || lastUndoAction is NoAction) {
    return;
  }

  switch (lastUndoAction.type) {
    case UndoActionType.deleteProject:
      _undoProjectDelete(lastUndoAction);
      break;
    case UndoActionType.deleteTaskList:
      _undoTaskListDelete(lastUndoAction);
      break;
    case UndoActionType.deleteTask:
      _undoTaskDelete(lastUndoAction);
      break;
    case UndoActionType.completeTask:
      _undoTaskComplete(lastUndoAction);
      break;
    case UndoActionType.multiCompleteTasks:
      _undoMultiCompleteTasks(lastUndoAction);
      break;
    case UndoActionType.multiDeleteTasks:
      _undoMultiDeleteTasks(lastUndoAction);
      break;
  }

  store.dispatch(SetLastUndoAction(lastUndoAction: NoAction()));

  var sharedPrefs = await SharedPreferences.getInstance();
  sharedPrefs.remove(undoActionSharedPreferencesKey);
}

void _undoMultiDeleteTasks(MultiDeleteTasksUndoActionModel undoAction) async {
  if (undoAction.taskRefPaths == null || undoAction.taskRefPaths.length == 0) {
    return;
  }

  var refs =
      undoAction.taskRefPaths.map((path) => Firestore.instance.document(path));
  final activityFeedRefs = undoAction.activityFeedReferencePaths
      .map((path) => Firestore.instance.document(path));
  var batch = Firestore.instance.batch();

  for (var ref in refs) {
    batch.updateData(ref, {'isDeleted': false});
  }

  for (var ref in activityFeedRefs) {
    batch.delete(ref);
  }

  try {
    await batch.commit();
  } catch (error) {
    throw error;
  }
}

void _undoMultiCompleteTasks(
    MultiCompleteTasksUndoActionModel lastUndoAction) async {
  var taskRefPaths = lastUndoAction.taskRefPaths;

  var refs = taskRefPaths.map((path) => Firestore.instance.document(path));
  var activityFeedRefs = lastUndoAction.activityFeedReferencePaths
      .map((path) => Firestore.instance.document(path));
  var batch = Firestore.instance.batch();

  for (var ref in refs) {
    batch.updateData(ref, {'isComplete': false});
  }

  for (var ref in activityFeedRefs) {
    batch.delete(ref);
  }

  try {
    await batch.commit();
  } catch (error) {
    throw error;
  }
}

void _undoTaskListDelete(DeleteTaskListUndoActionModel undoAction) async {
  var ref = Firestore.instance.document(undoAction.taskListRefPath);
  var activityFeedRef =
      Firestore.instance.document(undoAction.activityFeedReferencePath);
  final batch = Firestore.instance.batch();

  batch.updateData(ref, {'isDeleted': false});
  batch.delete(activityFeedRef);

  try {
    await batch.commit();
  } catch (error) {
    throw error;
  }
}

void _undoProjectDelete(DeleteProjectUndoActionModel undoAction) async {
  var ref = Firestore.instance.document(undoAction.projectPath);

  try {
    var batch = Firestore.instance.batch();
    batch.updateData(ref, {'deleted': Timestamp.fromDate(DateTime.now())});
    batch.updateData(ref, {'isDeleted': false});

    await batch.commit();
  } catch (error) {
    throw error;
  }
}

void _undoTaskComplete(CompleteTaskUndoActionModel undoAction) async {
  var ref = Firestore.instance.document(undoAction.taskRefPath);
  var activityFeedRef =
      Firestore.instance.document(undoAction.activityFeedReferencePath);
  final batch = Firestore.instance.batch();

  batch.updateData(ref, {'isComplete': false});
  batch.delete(activityFeedRef);

  try {
    await batch.commit();
  } catch (error) {
    throw error;
  }
}

void _undoTaskDelete(DeleteTaskUndoActionModel undoAction) async {
  var ref = Firestore.instance.document(undoAction.taskRefPath);
  var activityFeedRef =
      Firestore.instance.document(undoAction.activityFeedReferencePath);
  var batch = Firestore.instance.batch();

  batch.updateData(ref, {'deleted': Timestamp.fromDate(DateTime.now())});
  batch.updateData(ref, {'isDeleted': false});
  batch.delete(activityFeedRef);

  try {
    await batch.commit();
  } catch (error) {
    throw error;
  }
}
