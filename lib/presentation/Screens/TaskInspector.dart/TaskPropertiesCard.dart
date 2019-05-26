import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/DateSelectListTile.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/NoteInputListItem.dart';

class TaskPropertiesCard extends StatelessWidget {
  final DateTime dueDate;
  final String note;
  final String taskName;
  final dynamic onDueDateChange;
  final dynamic onNoteChange;

  TaskPropertiesCard({
    this.dueDate,
    this.onDueDateChange,
    this.note,
    this.onNoteChange,
    this.taskName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      child: Column(
        children: <Widget>[
          DateSelectListTile(
            firstDate: DateTime.now().subtract(Duration(days: 360)),
            lastDate: DateTime.now().add(Duration(days: 360)),
            initialDate: dueDate ?? DateTime.now(),
            onChange: onDueDateChange,
            hintText: 'Pick due date',
          ),
          NoteInputListItem(
            note: note,
            onChange: onNoteChange,
            taskName: taskName,
          )
        ]
      )
    );
  }
}