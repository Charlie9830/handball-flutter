import 'package:flutter/material.dart';
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

  const ProjectMenu(
      {Key key,
      this.listSorting,
      this.onSetListSorting,
      this.onShowOnlySelfTasksChanged,
      this.showOnlySelfTasks,
      this.isProjectShared,
      this.showCompletedTasks,
      this.onShowCompletedTasksChanged,
      this.onRenameProject})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: Icon(Icons.more_vert),
        onSelected: (value) => _handleSelection(value),
        itemBuilder: (context) {
          return <PopupMenuEntry<dynamic>>[
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
                child: Text('Rename project'), value: 'rename-project')
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
      default:
        break;
    }
  }
}
