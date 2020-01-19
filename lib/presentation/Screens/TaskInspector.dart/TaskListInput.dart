import 'package:flutter/material.dart';

class TaskListInput extends StatelessWidget {
  final String currentTaskListName;
  final dynamic onOpen;

  const TaskListInput({Key key, this.currentTaskListName, this.onOpen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.list),
      title: Text(currentTaskListName ?? ''),
      onTap: onOpen,
    );
  }
}
