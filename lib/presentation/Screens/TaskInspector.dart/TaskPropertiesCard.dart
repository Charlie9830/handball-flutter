import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/DueDateListItem.dart';
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
          DueDateListItem(
            dueDate: dueDate,
            onDueDateChange: onDueDateChange,
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