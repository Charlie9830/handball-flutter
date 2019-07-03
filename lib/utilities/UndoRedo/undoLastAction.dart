import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/UndoActions/DeleteProjectUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/DeleteTaskListUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/DeleteTaskUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/CompleteTaskUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/MultiCompleteTasksUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/NoAction.dart';
import 'package:handball_flutter/redux/actions.dart';
import 'package:handball_flutter/redux/appState.dart';
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
    case UndoActionType.moveTask:
      // TODO: Handle this case.
      break;
    case UndoActionType.multiMoveTask:
      // TODO: Handle this case.
      break;
  }

  store.dispatch(SetLastUndoAction(lastUndoAction: NoAction()));

  var sharedPrefs = await SharedPreferences.getInstance();
  sharedPrefs.remove(undoActionSharedPreferencesKey);
}

void _undoMultiCompleteTasks(MultiCompleteTasksUndoActionModel lastUndoAction) async {
  var taskRefPaths = lastUndoAction.taskRefPaths;

  var refs = taskRefPaths.map((path) => Firestore.instance.document(path));
  var batch = Firestore.instance.batch();

  for (var ref in refs) {
    batch.updateData(ref, {'isComplete': false});
  }

  try {
    await batch.commit();
  } catch(error) {
    throw error;
  }
}

void _undoTaskListDelete(DeleteTaskListUndoActionModel undoAction) async {
  var ref = Firestore.instance.document(undoAction.taskListRefPath);

  try {
    await ref.updateData({'isDeleted': false});
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

  try {
    ref.updateData({'isComplete': false});
  } catch (error) {
    throw error;
  }
}

void _undoTaskDelete(DeleteTaskUndoActionModel undoAction) async {
  var ref = Firestore.instance.document(undoAction.taskRefPath);

  try {
    var batch = Firestore.instance.batch();

    batch.updateData(ref, {'deleted': Timestamp.fromDate(DateTime.now())});
    batch.updateData(ref, {'isDeleted': false});

    batch.commit();
  } catch (error) {
    throw error;
  }
}
