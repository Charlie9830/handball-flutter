import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
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
  } catch(error) {
    throw error;
  }

}

_executeLastUndoAction(UndoActionModel lastUndoAction) async {
  if (lastUndoAction == null || lastUndoAction is NoAction) {
    // No action required.
    return;
  }

  switch(lastUndoAction.type) {
    case UndoActionType.deleteProject:
      // TODO: Handle this case.
      break;
    case UndoActionType.deleteTaskList:
      // TODO: Handle this case.
      break;
    case UndoActionType.deleteTask:
      _executeDeleteTask(lastUndoAction);
      break;
    case UndoActionType.completeTask:
      // No execute action required.
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

  return;
}

_executeDeleteTask(DeleteTaskUndoActionModel undoAction) async {
  var ref = Firestore.instance.document(undoAction.taskRefPath);

  try {
    await ref.delete();
  } catch(error) {
    
    throw error;
  }
}



