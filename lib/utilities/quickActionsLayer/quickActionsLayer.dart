import 'package:flutter/material.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/redux/asyncActions.dart';
import 'package:handball_flutter/redux/syncActions.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:redux/redux.dart';

class QuickActionsLayer {
  static final QuickActions _quickActions = QuickActions();
  static final List<ProjectShortcut> _currentShortcutProjects = [];

  static void initialize(Store<AppState> store) async {
    _quickActions.initialize((type) => _handleQuickActionSelect(type, store));
  }

  static void reAssertShortcuts() {
    for (var item in _currentShortcutProjects) {
      addProjectShortcut(item.uid, item.projectName);
    }
  }

  static void clearAllShortcutItems() async {
    return _quickActions.clearShortcutItems();
  }

  static void addProjectShortcut(String projectId, String projectName) async {
    if (_alreadyContainsProjectShortcut(projectId)) {
      return;
    }

    _currentShortcutProjects
        .add(ProjectShortcut(uid: projectId, projectName: projectName));

    await _quickActions.setShortcutItems(_currentShortcutProjects
        .map((item) => ShortcutItem(
            localizedTitle: item.projectName,
            type: item.uid,
            icon: 'quick_action_add_task'))
        .toList());
  }

  static void updateProjectShortcut(
      String projectId, String newProjectName) async {
    final index =
        _currentShortcutProjects.indexWhere((item) => item.uid == projectId);

    if (index != -1) {
      _currentShortcutProjects[index] =
          _currentShortcutProjects[index].copyWith(projectName: newProjectName);

      await _quickActions.setShortcutItems(_currentShortcutProjects
          .map((item) => ShortcutItem(
              localizedTitle:
                  item.uid == projectId ? newProjectName : item.projectName,
              type: item.uid,
              icon: 'quick_action_add_task'))
          .toList());
    }
  }

  static void deleteProjectShortcut(String projectId) async {
    if (_alreadyContainsProjectShortcut(projectId) == true) {
      await _quickActions.setShortcutItems(_currentShortcutProjects
          .where((item) => item.uid != projectId)
          .map((item) => ShortcutItem(localizedTitle: item.projectName, type: item.uid, icon: 'quick_action_add_task'))
          .toList());
    }
  }

  static bool _alreadyContainsProjectShortcut(String projectId) {
    return _currentShortcutProjects
            .indexWhere((item) => item.uid == projectId) !=
        -1;
  }

  static void _handleQuickActionSelect(String type, Store<AppState> store) {
    final projectId = type;
    store.dispatch(SelectProject(projectId));
    store.dispatch(addNewTaskWithDialog(projectId, homeScreenScaffoldKey.currentContext));
  }
}

class PendingQuickAction {
  final String projectId;
  final Store<AppState> store;

  PendingQuickAction({this.projectId, this.store});
}

class ProjectShortcut {
  final String uid;
  final String projectName;

  ProjectShortcut({
    @required this.uid,
    @required this.projectName,
  });

  ProjectShortcut copyWith({
    String uid,
    String projectName,
  }) {
    return ProjectShortcut(
      uid: uid ?? this.uid,
      projectName: projectName ?? this.projectName,
    );
  }
}
