import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';

class ProjectMenu extends StatelessWidget {
  final TaskListSorting listSorting;
  final dynamic onSetListSorting;
  const ProjectMenu({Key key, this.listSorting, this.onSetListSorting})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
        icon: Icon(Icons.more_vert),
        onSelected: (value) => _handleSelection(value),
        itemBuilder: (context) {
          return <PopupMenuEntry<dynamic>>[
            PopupMenuItem(
              child: Text('Sort lists by', style: Theme.of(context).textTheme.subtitle),
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

      default:
        break;
    }
  }
}
