import 'dart:convert';

import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/UndoActions/UndoAction.dart';
import 'package:meta/meta.dart';

class DeleteTaskUndoActionModel extends UndoActionModel {
  String taskRefPath;

  DeleteTaskUndoActionModel({
    @required String friendlyName,
    @required this.taskRefPath,
  }) : super(type: UndoActionType.deleteTask);

  DeleteTaskUndoActionModel.fromMap(Map<dynamic, dynamic> map) {
    this.taskRefPath = map['taskRefPath'];
  }

  @override
  String toJSON() {
    var encoder = JsonEncoder();
    return encoder.convert({
      'type': this.type?.index ?? -1,
      'taskRefPath': this.taskRefPath 
    });
  }
}
