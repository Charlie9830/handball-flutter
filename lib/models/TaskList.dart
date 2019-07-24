import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/ChecklistSettings.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskListSettings.dart';
import 'package:handball_flutter/utilities/Colors/AppThemeColors.dart';
import 'package:handball_flutter/utilities/coerceDate.dart';
import 'package:meta/meta.dart';

class TaskListModel {
  String uid;
  String project;
  String taskListName;
  DateTime dateAdded;
  TaskListSettingsModel settings;
  bool isDeleted;
  bool hasCustomColor;
  int customColorIndex;

  /*
    Update CopyWith Method Below.
  */

  TaskListModel({
    @required this.uid,
    @required this.project,
    this.taskListName = '',
    this.settings,
    this.isDeleted = false,
    this.hasCustomColor,
    this.customColorIndex,
    @required this.dateAdded,
  });

  TaskListModel.fromDoc(DocumentSnapshot doc) {
    this.uid = doc['uid'];
    this.project = doc['project'];
    this.taskListName = doc['taskListName'];
    this.dateAdded = coerceDate(doc['created']);
    this.settings = TaskListSettingsModel.fromDocMap(doc['settings']);
    this.isDeleted = doc['isDeleted'] ?? false;
    this.hasCustomColor = doc['hasCustomColor'] ?? false;
    this.customColorIndex = doc['customColorIndex'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'project': this.project,
      'taskListName': this.taskListName,
      'dateAdded': this.dateAdded ?? '',
      'settings': this.settings?.toMap() ?? TaskListSettingsModel().toMap(),
      'isDeleted': this.isDeleted ?? false,
      'hasCustomColor': this.hasCustomColor,
      'customColorIndex': this.customColorIndex,
    };
  }

  TaskListModel copyWith({
    String uid,
    String project,
    String taskListName,
    DateTime dateAdded,
    TaskListSettingsModel settings,
    bool isDeleted,
    bool hasCustomColor,
    int customColorIndex,
  }) {
    return TaskListModel(
      uid: uid ?? this.uid,
      project: project ?? this.project,
      taskListName: taskListName ?? this.taskListName,
      dateAdded: dateAdded ?? this.dateAdded,
      settings: settings ?? this.settings,
      isDeleted: isDeleted ?? this.isDeleted,
      hasCustomColor: hasCustomColor ?? this.hasCustomColor,
      customColorIndex: customColorIndex ?? this.customColorIndex,
    );
  }

  Color get customColor {
    if (hasCustomColor == true && customColorIndex < AppThemeColors.materialColors.length) {
      return AppThemeColors.materialColors[customColorIndex];
    }

    return null;
  }
}

class TaskListViewModel {
  TaskListModel data;
  List<TaskViewModel> childTaskViewModels = [];
  bool isMenuDisabled;
  bool isFocused;
  final onDelete;
  final onRename;
  final onAddNewTaskButtonPressed;
  final onSortingChange;
  final onOpenChecklistSettings;
  final onMoveToProject;
  final onChooseColor;
  final onTaskListFocus;

  TaskListViewModel({
    this.data,
    this.childTaskViewModels,
    this.isMenuDisabled,
    this.onTaskListFocus,
    this.isFocused,
    this.onDelete,
    this.onRename,
    this.onAddNewTaskButtonPressed,
    this.onSortingChange,
    this.onOpenChecklistSettings,
    this.onMoveToProject,
    this.onChooseColor,
  });
}
