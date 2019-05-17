import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/presentation/TaskList/TaskListSettingsMenu.dart';

class TaskListHeader extends StatelessWidget {
  final String name;
  final TaskSorting sorting;
  final onDelete;
  final onRename;
  final onAddTaskButtonPressed;
  final onSortingChange;

  TaskListHeader({
    Key key,
    this.name,
    this.sorting,
    this.onDelete,
    this.onRename,
    this.onAddTaskButtonPressed,
    this.onSortingChange,
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
            sorting: sorting,
          ),
          Expanded(
            child: Text(
              name,
              textAlign: TextAlign.center,
              )
          ),
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