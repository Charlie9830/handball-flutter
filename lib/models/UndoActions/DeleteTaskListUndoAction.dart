import 'dart:convert';

import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/UndoActions/UndoAction.dart';
import 'package:meta/meta.dart';

class DeleteTaskListUndoActionModel extends UndoActionModel {
  String taskListRefPath;
  List<String> childTaskPaths;
  String activityFeedReferencePath;

  DeleteTaskListUndoActionModel({
    @required this.taskListRefPath,
    @required this.childTaskPaths,
    @required this.activityFeedReferencePath,
  }) : super(type: UndoActionType.deleteTaskList);

  DeleteTaskListUndoActionModel.fromMap(Map<dynamic, dynamic> map) {
    this.type = UndoActionType.deleteTaskList;
    this.taskListRefPath = map['taskListRefPath'];
    this.childTaskPaths = map['childTaskPaths'];
    this.activityFeedReferencePath = map['activityFeedReference'];
  }

  @override
  String toJSON() {
    var encoder = JsonEncoder();
    return encoder.convert({
      'type': this.type?.index ?? -1,
      'taskListRefPath': this.taskListRefPath,
      'childTaskPaths': this.childTaskPaths,
      'activityFeedReference': this.activityFeedReferencePath,
    });
  }
}
