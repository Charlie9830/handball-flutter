import 'dart:convert';

import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/UndoActions/DeleteTaskUndoAction.dart';
import 'package:handball_flutter/models/UndoActions/UndoAction.dart';

UndoActionModel parseUndoAction(String json) {
  if (json == null) {
    return null;
  }

  var decoder = JsonDecoder();
  Map<dynamic, dynamic> map = decoder.convert(json);

  var type = _parseUndoActionType(map['type']);

  if (type == null) {
    return null;
  }

  switch(type) {
    case UndoActionType.deleteProject:
      // TODO: Handle this case.
      break;
    case UndoActionType.deleteTaskList:
      // TODO: Handle this case.
      break;
    case UndoActionType.deleteTask:
      return DeleteTaskUndoActionModel.fromMap(map);
    case UndoActionType.completeTask:
      // TODO: Handle this case.
      break;
    case UndoActionType.multiCompleteTasks:
      // TODO: Handle this case.
      break;
    case UndoActionType.multiDeleteTasks:
      // TODO: Handle this case.
      break;
    default:
  }

  return null;
  
}

UndoActionType _parseUndoActionType(int index) {
  if (index == null || index == -1) {
    return null;
  }

  if (index < UndoActionType.values.length) {
    return UndoActionType.values[index];
  }
  return null;
}