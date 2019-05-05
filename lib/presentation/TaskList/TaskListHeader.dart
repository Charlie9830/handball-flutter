import 'package:flutter/material.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/presentation/TaskList/TaskListSettingsMenu.dart';

class TaskListHeader extends StatelessWidget {
  final String name;
  final bool isFocused;
  final onDelete;
  final onRename;

  TaskListHeader({
    Key key,
    this.name,
    this.isFocused,
    this.onDelete,
    this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isFocused ? Theme.of(context).colorScheme.primary: Theme.of(context).colorScheme.primaryVariant;

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
          )
        ],
      ),
      color: backgroundColor,
    );
  }
}