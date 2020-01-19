import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/ChecklistSettings.dart';

class TaskListSettingsModel {
  TaskSorting sortBy;
  ChecklistSettingsModel checklistSettings;

  TaskListSettingsModel({
    this.sortBy = defaultTaskSorting,
    this.checklistSettings,
  });

  TaskListSettingsModel.fromDocMap(Map<dynamic, dynamic> docMap) {
    if (docMap == null) {
      this.sortBy = defaultTaskSorting;
      this.checklistSettings = ChecklistSettingsModel();
      return;
    }

    this.sortBy = _parseSortBy(docMap['sortBy']);
    this.checklistSettings = docMap['checklistSettings'] == null
        ? ChecklistSettingsModel()
        : ChecklistSettingsModel.fromDocMap(docMap['checklistSettings']);
  }

  Map<String, dynamic> toMap() {
    return {
      'sortBy': _convertSortByToString(this.sortBy),
      'checklistSettings':
          this.checklistSettings?.toMap() ?? ChecklistSettingsModel().toMap(),
    };
  }

  TaskListSettingsModel copyWith({
    TaskSorting sortBy,
    ChecklistSettingsModel checklistSettings,
  }) {
    return TaskListSettingsModel(
      sortBy: sortBy ?? this.sortBy,
      checklistSettings: checklistSettings ?? this.checklistSettings,
    );
  }

  String _convertSortByToString(TaskSorting sortBy) {
    switch (sortBy) {
      case TaskSorting.completed:
        return 'completed';

      case TaskSorting.priority:
        return 'priority';

      case TaskSorting.dueDate:
        return 'dueDate';

      case TaskSorting.dateAdded:
        return 'dateAdded';

      case TaskSorting.assignee:
        return 'assignee';

      case TaskSorting.alphabetically:
        return 'alphabetically';

      case TaskSorting.auto:
        return 'auto';

      default:
        return 'dateAdded';
    }
  }

  TaskSorting _parseSortBy(String sortBy) {
    if (sortBy == null) {
      return defaultTaskSorting;
    }

    switch (sortBy) {
      case '':
        return defaultTaskSorting;
      
      case 'auto':
        return TaskSorting.auto;

      case 'completed':
        return TaskSorting.completed;

      case 'dateAdded':
        return TaskSorting.dateAdded;

      case 'dueDate':
        return TaskSorting.dueDate;

      case 'assignee':
        return TaskSorting.assignee;

      case 'alphabetically':
        return TaskSorting.alphabetically;

      case 'priority':
        return TaskSorting.priority;

      default:
        return TaskSorting.dateAdded;
    }
  }
}
