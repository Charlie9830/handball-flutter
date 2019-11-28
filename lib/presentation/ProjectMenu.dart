import 'package:flutter/material.dart';
import 'package:handball_flutter/InheritatedWidgets/EnableStates.dart';
import 'package:handball_flutter/enums.dart';

class ProjectMenu extends StatelessWidget {
  final TaskListSorting listSorting;
  final bool showCompletedTasks;
  final bool isProjectShared;
  final bool showOnlySelfTasks;
  final dynamic onSetListSorting;
  final dynamic onShowOnlySelfTasksChanged;
  final dynamic onShowCompletedTasksChanged;
  final dynamic onRenameProject;
  final dynamic onUndoAction;
  final dynamic onArchiveProject;
  final dynamic onActivityFeedOpen;

  const ProjectMenu(
      {Key key,
      this.listSorting,
      this.onSetListSorting,
      this.onShowOnlySelfTasksChanged,
      this.showOnlySelfTasks,
      this.isProjectShared,
      this.showCompletedTasks,
      this.onShowCompletedTasksChanged,
      this.onRenameProject,
      this.onUndoAction,
      this.onArchiveProject,
      this.onActivityFeedOpen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: Icon(Icons.more_vert),
        onSelected: (value) => _handleSelection(value),
        itemBuilder: (context) {
          return <PopupMenuEntry<dynamic>>[
            PopupMenuItem(
              enabled: EnableStates.of(context).state.canUndo,
              child: Row(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.undo),
                ),
                Text('Undo')
              ]),
              value: 'undo-action',
            ),
            PopupMenuItem(
                child: Text(
                    showCompletedTasks ? 'Hide Completed' : 'Show Completed'),
                value: 'show-completed-tasks'),
            PopupMenuDivider(),
            PopupMenuItem(
              child: Text('Sort lists by',
                  style: Theme.of(context).textTheme.subtitle),
              enabled: false,
            ),
            CheckedPopupMenuItem(
              child: Text("Date Created"),
              value: 'list-sorting-date-created',
              checked: listSorting == TaskListSorting.dateAdded,
            ),
            CheckedPopupMenuItem(
              child: Text("Custom Order"),
              value: 'list-sorting-custom',
              checked: listSorting == TaskListSorting.custom,
            ),
            if (isProjectShared == true) PopupMenuDivider(),
            if (isProjectShared == true)
              PopupMenuItem(
                child: Text(showOnlySelfTasks == true
                    ? 'Show all Tasks'
                    : 'Show only my tasks'),
                value: 'show-self-tasks',
              ),
            PopupMenuItem(
                child: Text('Rename project'), value: 'rename-project'),
            PopupMenuItem(
              enabled: EnableStates.of(context).state.canArchiveProject,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.archive),
                  ),
                  Text('Archive Project'),
                ],
              ),
              value: 'archive-project',
            ),
            PopupMenuDivider(),
            PopupMenuItem(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.notifications),
                  ),
                  Text('Activity Feed'),
                ],
              ),
              value: 'activity-feed',
            ),
          ];
        });
  }

  void _handleSelection(dynamic value) {
    switch (value) {
      case 'list-sorting-date-created':
        onSetListSorting(TaskListSorting.dateAdded);
        break;

      case 'list-sorting-custom':
        onSetListSorting(TaskListSorting.custom);
        break;

      case 'show-self-tasks':
        onShowOnlySelfTasksChanged(!showOnlySelfTasks); 
        break;

      case 'show-completed-tasks':
        onShowCompletedTasksChanged(!showCompletedTasks);
        break;

      case 'rename-project':
        onRenameProject();
        break;

      case 'undo-action':
        onUndoAction();
        break;

      case 'archive-project':
        onArchiveProject();
        break;

      case 'activity-feed':
        onActivityFeedOpen();
        break;

      default:
        break;
    }
  }
}
