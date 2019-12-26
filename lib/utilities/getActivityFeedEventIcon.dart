import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';

IconData getActivityFeedEventIcon(ActivityFeedEventType type) {

  switch (type) {
    case ActivityFeedEventType.addTask:
      return Icons.add;

    case ActivityFeedEventType.deleteTask:
      return Icons.delete;

    case ActivityFeedEventType.completeTask:
      return Icons.check;

    case ActivityFeedEventType.editTask:
      return Icons.edit;

    case ActivityFeedEventType.unCompleteTask:
      return Icons.indeterminate_check_box;

    case ActivityFeedEventType.moveTask:
      return Icons.archive;

    case ActivityFeedEventType.commentOnTask:
      return Icons.add_comment;

    case ActivityFeedEventType.prioritizeTask:
      return Icons.star;

    case ActivityFeedEventType.unPrioritizeTask:
      return Icons.star_border;

    case ActivityFeedEventType.changeDueDate:
      return Icons.calendar_today;

    case ActivityFeedEventType.addDetails:
      return Icons.details;

    case ActivityFeedEventType.addList:
      return Icons.playlist_add;

    case ActivityFeedEventType.deleteList:
      return Icons.delete;

    case ActivityFeedEventType.renameList:
      return Icons.edit;

    case ActivityFeedEventType.addMember:
      return Icons.person_add;

    case ActivityFeedEventType.removeMember:
      return Icons.clear;

    case ActivityFeedEventType.renameProject:
      return Icons.edit;

    case ActivityFeedEventType.renewChecklist:
      return Icons.playlist_add_check;

    case ActivityFeedEventType.assignmentUpdate:
      return Icons.assignment;

    case ActivityFeedEventType.moveList:
      return Icons.archive;

    case ActivityFeedEventType.addProject:
      return Icons.add;

    case ActivityFeedEventType.reColorList:
      return Icons.color_lens;

    default:
      return Icons.notification_important;
  }
}
