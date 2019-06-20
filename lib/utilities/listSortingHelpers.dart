import 'package:handball_flutter/enums.dart';

String convertTaskListSorting(TaskListSorting sorting) {
  switch (sorting) {
    case TaskListSorting.dateAdded:
      return 'dateAdded';

    case TaskListSorting.custom:
      return 'custom';

    default:
      return 'dateAdded';
  }
}

TaskListSorting parseTaskListSorting(String value) {
    switch (value) {
      case 'dateAdded':
        return TaskListSorting.dateAdded;

      case 'custom':
        return TaskListSorting.custom;

      default:
        return TaskListSorting.dateAdded;
    }
  }