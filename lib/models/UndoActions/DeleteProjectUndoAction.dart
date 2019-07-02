import 'dart:convert';

import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/UndoActions/UndoAction.dart';
import 'package:meta/meta.dart';

class DeleteProjectUndoActionModel extends UndoActionModel {
  String projectId;
  String userId;
  List<String> allMemberIds;
  List<String> otherMemberIds;
  List<String> taskIds;
  List<String> taskListIds;
  String tasksPath;
  String taskListsPath;
  String membersPath;
  String projectPath;
  String projectIdPath;

  DeleteProjectUndoActionModel({
    @required this.projectId,
    @required this.userId,
    @required this.allMemberIds,
    @required this.otherMemberIds,
    @required this.taskIds,
    @required this.taskListIds,
    @required this.tasksPath,
    @required this.taskListsPath,
    @required this.membersPath,
    @required this.projectPath,
    @required this.projectIdPath,
  }) : super(type: UndoActionType.deleteProject);

  DeleteProjectUndoActionModel.fromMap(Map<dynamic, dynamic> map) {
    this.type = UndoActionType.deleteProject;

    this.projectId = map['projectId'];
    this.userId = map['userId'];
    this.allMemberIds = map['allMemberIds'];
    this.otherMemberIds = map['otherMemberIds'];
    this.taskIds = map['taskIds'];
    this.taskListIds = map['taskListIds'];
  }

  @override
  String toJSON() {
    var encoder = JsonEncoder();
    return encoder.convert({
      'projectId': this.projectId,
      'userId': this.userId,
      'allMemberIds': this.allMemberIds,
      'otherMemberIds': this.otherMemberIds,
      'taskIds': this.taskIds,
      'taskListIds': this.taskListIds,
    });
  }
}
