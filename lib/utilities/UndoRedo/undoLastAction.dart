import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/UndoActions/DeleteTaskUndoAction.dart';
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
      // TODO: Handle this case.
      break;
    case UndoActionType.deleteTaskList:
      // TODO: Handle this case.
      break;
    case UndoActionType.deleteTask:
      undoTaskDelete(lastUndoAction);
      break;
    case UndoActionType.completeTask:
      // TODO: Handle this case.
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

void undoTaskDelete(DeleteTaskUndoActionModel undoAction) async {
  var ref = Firestore.instance.document(undoAction.taskRefPath);
  

  try {
   ref.updateData({'isDeleted': false}); 
  } catch(error) {
    throw error;
  }
}