import 'package:flutter/material.dart';

class TaskListSortTile extends StatelessWidget {
  final String title;
  TaskListSortTile({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.reorder),
    );
  }
}
