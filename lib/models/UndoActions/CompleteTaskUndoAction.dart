import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/UndoActions/UndoAction.dart';
import 'package:meta/meta.dart';

class CompleteTaskUndoActionModel extends UndoActionModel {
  String taskRefPath;
  String activityFeedReferencePath;

  CompleteTaskUndoActionModel({
    @required this.taskRefPath,
    @required this.activityFeedReferencePath,
  }) : super(type: UndoActionType.completeTask);

  CompleteTaskUndoActionModel.fromMap(Map<dynamic, dynamic> map) {
    this.type = UndoActionType.completeTask;
    this.taskRefPath = map['taskRefPath'];
    this.activityFeedReferencePath = map['activityFeedReference'];
  }

  @override
  String toJSON() {
    var encoder = JsonEncoder();
    return encoder.convert({
      'type': this.type?.index ?? -1,
      'taskRefPath': this.taskRefPath,
      'activityFeedReference': this.activityFeedReferencePath
    });
  }
}
