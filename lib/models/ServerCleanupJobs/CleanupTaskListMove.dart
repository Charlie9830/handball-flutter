import 'package:meta/meta.dart';

class CleanupTaskListMoveJobModel {
  String type = "CLEANUP_TASKLIST_MOVE";
  CleanupTaskListMoveJobPayload payload;

  CleanupTaskListMoveJobModel({
    this.payload,
  });

  Map<String, dynamic> toMap() {
    return {
      'type': this.type,
      'payload': this.payload.toMap(),
    };
  }
}

class CleanupTaskListMoveJobPayload {
  final String sourceProjectId;
  final String targetProjectId;
  final String taskListId;
  final List<String> taskIds;
  final String targetTasksRefPath;
  final String targetTaskListRefPath;
  final String sourceTasksRefPath;
  final String sourceTaskListRefPath;

  CleanupTaskListMoveJobPayload({
    @required this.sourceProjectId,
    @required this.targetProjectId,
    @required this.taskListId,
    @required this.taskIds,
    @required this.targetTasksRefPath,
    @required this.targetTaskListRefPath,
    @required this.sourceTasksRefPath,
    @required this.sourceTaskListRefPath
  });

  Map<dynamic, dynamic> toMap() {
    return {
      'sourceProjectId': this.sourceProjectId,
      'targetProjectId': this.targetProjectId,
      'taskListId': this.taskListId,
      'taskIds': this.taskIds,
      'targetTasksRefPath': this.targetTasksRefPath,
      'targetTaskListRefPath': this.targetTaskListRefPath,
      'sourceTasksRefPath': this.sourceTasksRefPath,
      'sourceTaskListRefPath': this.sourceTaskListRefPath,
    };
  }
}