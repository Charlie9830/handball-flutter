import 'dart:convert';

import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/UndoActions/UndoAction.dart';
import 'package:meta/meta.dart';

class DeleteProjectUndoActionModel extends UndoActionModel {
  List<String> taskIds;
  List<String> taskListIds;
  String tasksPath;
  String taskListsPath;
  String projectPath;
  String projectIdPath;

  DeleteProjectUndoActionModel({
    @required this.taskIds,
    @required this.taskListIds,
    @required this.tasksPath,
    @required this.taskListsPath,
    @required this.projectPath,
    @required this.projectIdPath,
  }) : super(type: UndoActionType.deleteProject);

  DeleteProjectUndoActionModel.fromMap(Map<dynamic, dynamic> map) {
    this.type = UndoActionType.deleteProject;
    this.taskIds = map['taskIds'];
    this.taskListIds = map['taskListIds'];
    this.tasksPath = map['tasksPath'];
    this.taskListsPath = map['taskListsPath'];
    this.projectPath = map['projectPath'];
    this.projectIdPath = map['projectIdPath'];
  }

  @override
  String toJSON() {
    var encoder = JsonEncoder();
    return encoder.convert({
      'taskIds': this.taskIds,
      'taskListIds': this.taskListIds,
      'tasksPath': this.tasksPath,
      'taskListsPath': this.taskListsPath,
      'projectPath': this.projectPath,
      'projectIdPath': this.projectIdPath,
    });
  }
}
