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
      return Icons.check;

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

    case ActivityFeedEventType.updateList:
      return Icons.edit;

    case ActivityFeedEventType.addMember:
      return Icons.person_add;
      
    case ActivityFeedEventType.removeMember:
      return Icons.clear;

    case ActivityFeedEventType.renameProject:
      return Icons.edit;

    case ActivityFeedEventType.renewChecklist:
      return Icons.playlist_add_check;
  }
}