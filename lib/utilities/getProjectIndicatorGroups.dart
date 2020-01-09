import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/IndicatorGroup.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/utilities/ParseDueDate.dart';

Map<String, IndicatorGroup> getProjectIndicatorGroups(
    List<TaskModel> tasks, Map<String, TaskListModel> deletedTaskLists, String userId) {
  var map = <String, IndicatorGroup>{};

  for (var task in tasks.where((item) => item.isComplete == false && deletedTaskLists.containsKey(item.taskList) == false)) {
    var hasUnreadComments = task.unseenTaskCommentMembers[userId] != null;

    if (task.dueDate != null || hasUnreadComments) {
      // Create an Entry for this Project in the map if not already existing.
      if (map[task.project] == null) {
        map[task.project] = IndicatorGroup();
      }

      map[task.project].hasUnreadComments = hasUnreadComments;

      var type = parseDueDate(task.isComplete, false, task.dueDate).type;
      switch (type) {
        case DueDateType.later:
          map[task.project].later += 1;
          break;

        case DueDateType.soon:
          map[task.project].soon += 1;
          break;

        case DueDateType.today:
          map[task.project].today += 1;
          break;

        case DueDateType.overdue:
          map[task.project].overdue += 1;
          break;

        default:
          break;
      }
    }
  }

  return map;
}
