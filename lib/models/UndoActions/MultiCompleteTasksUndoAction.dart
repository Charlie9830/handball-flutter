import 'dart:convert';

import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/UndoActions/UndoAction.dart';
import 'package:meta/meta.dart';

class MultiCompleteTasksUndoActionModel extends UndoActionModel {
  List<String> taskRefPaths;
  List<String> activityFeedReferencePaths;

  MultiCompleteTasksUndoActionModel({
    @required this.taskRefPaths,
    @required this.activityFeedReferencePaths,
  }) : super(type: UndoActionType.multiCompleteTasks);

  MultiCompleteTasksUndoActionModel.fromMap(Map<dynamic, dynamic> map) {
    this.type = UndoActionType.completeTask;
    this.taskRefPaths = map['taskRefPaths'];
  }

  @override
  String toJSON() {
    var encoder = JsonEncoder();
    return encoder.convert(
        {'type': this.type?.index ?? -1, 'taskRefPaths': this.taskRefPaths});
  }
}
