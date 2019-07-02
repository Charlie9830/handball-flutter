import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/UndoActions/DeleteProjectUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/DeleteTaskListUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/DeleteTaskUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/CompleteTaskUndoAction.dart';
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

  switch(lastUndoAction.type) {
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
    case UndoActionType.multiCompletedTasks:
      // TODO: Handle this case.
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

void _undoTaskListDelete(DeleteTaskListUndoActionModel undoAction) async {
  var ref = Firestore.instance.document(undoAction.taskListRefPath);

  try {
    await ref.updateData({'isDeleted': false});
  } catch(error) {
    throw error;
  }
}

void _undoProjectDelete(DeleteProjectUndoActionModel undoAction) async {
  var ref = Firestore.instance.document(undoAction.projectPath);

  try {
    await ref.updateData({'isDeleted': false});
  } catch(error) {
    throw error;
  }
}

void _undoTaskComplete(CompleteTaskUndoActionModel undoAction) async {
  var ref = Firestore.instance.document(undoAction.taskRefPath);

  try {
    ref.updateData({'isComplete': false});
  } catch(error) {
    throw error;
  }
}

void _undoTaskDelete(DeleteTaskUndoActionModel undoAction) async {
  var ref = Firestore.instance.document(undoAction.taskRefPath);
  

  try {
   ref.updateData({'isDeleted': false}); 
  } catch(error) {
    throw error;
  }
}