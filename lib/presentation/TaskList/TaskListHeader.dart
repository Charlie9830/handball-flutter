import 'package:flutter/material.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/presentation/TaskList/TaskListSettingsMenu.dart';

class TaskListHeader extends StatelessWidget {
  final String name;
  final onDelete;
  final onRename;
  final onAddTaskButtonPressed;

  TaskListHeader({
    Key key,
    this.name,
    this.onDelete,
    this.onRename,
    this.onAddTaskButtonPressed,
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