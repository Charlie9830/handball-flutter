import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/IndicatorGroup.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/utilities/ParseDueDate.dart';

Map<String,IndicatorGroup> getProjectIndicatorGroups(List<TaskModel> tasks) {
  var map = <String, IndicatorGroup> {};

  for (var task in tasks) {
    if (task.dueDate != null && task.isComplete != true) {
      // Create an Entry for this Project in the map if not already existing.
      if (map[task.project] == null) {
        map[task.project] = IndicatorGroup();
      }
    }

    var type = ParseDueDate(task.isComplete, task.dueDate).type;
    switch(type) {
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

  return map;
}