import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/DueDateListItem.dart';

class TaskPropertiesCard extends StatelessWidget {
  final DateTime dueDate;
  final dynamic onDueDateChange;

  TaskPropertiesCard({
    this.dueDate,
    this.onDueDateChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: Column(
        children: <Widget>[
          new DueDateListItem(
            dueDate: dueDate,
            onDueDateChange: onDueDateChange,
          ),
        ]
      )
    );
  }
}