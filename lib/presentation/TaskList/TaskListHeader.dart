import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/presentation/TaskList/TaskListSettingsMenu.dart';

class TaskListHeader extends StatelessWidget {
  final String name;
  final TaskSorting sorting;
  final bool isChecklist;
  final onDelete;
  final onRename;
  final onAddTaskButtonPressed;
  final onSortingChange;
  final onOpenChecklistSettings;

  TaskListHeader({
    Key key,
    this.name,
    this.isChecklist,
    this.sorting,
    this.onDelete,
    this.onRename,
    this.onAddTaskButtonPressed,
    this.onSortingChange,
    this.onOpenChecklistSettings,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).colorScheme.secondary;

    return new Container(
      child: Row(
        children: <Widget>[
          TaskListSettingsMenu(
            onDelete: onDelete,
            onRename: onRename,
            onSortingChange: onSortingChange,
            onOpenChecklistSettings: onOpenChecklistSettings,
            sorting: sorting,
          ),
          if (isChecklist == true)
            IconButton(
              icon: Icon(Icons.playlist_add_check),
              onPressed: () => onOpenChecklistSettings()),
          Expanded(
              child: Text(
            name,
            textAlign: TextAlign.center,
          )),
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: onAddTaskButtonPressed,
          )
        ],
      ),
      color: backgroundColor,
    );
  }
}
