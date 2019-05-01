import 'package:flutter/material.dart';
import 'package:handball_flutter/models/TaskList.dart';

class TaskListHeader extends StatelessWidget {
  final String name;
  final bool isFocused;

  TaskListHeader({
    Key key,
    this.name,
    this.isFocused,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isFocused ? Theme.of(context).colorScheme.primary: Theme.of(context).colorScheme.primaryVariant;

    return new Container(
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
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