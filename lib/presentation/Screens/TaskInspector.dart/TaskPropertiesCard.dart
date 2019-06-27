import 'package:flutter/material.dart';
import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/presentation/DateSelectListTile.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/NoteInputListItem.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/TaskAssignmentInput.dart';

class TaskPropertiesCard extends StatelessWidget {
  final DateTime dueDate;
  final String note;
  final String taskName;
  final bool isAssignmentInputVisible;
  final List<Assignment> assignments;
  final List<Assignment> assignmentOptions;
  final dynamic onDueDateChange;
  final dynamic onNoteChange;
  final dynamic onAssignmentsChange;

  TaskPropertiesCard({
    this.dueDate,
    this.onDueDateChange,
    this.note,
    this.isAssignmentInputVisible,
    this.assignmentOptions,
    this.assignments,
    this.onNoteChange,
    this.taskName,
    this.onAssignmentsChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).cardColor,
        child: Column(children: <Widget>[
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
          ),
          if (isAssignmentInputVisible == true)
            TaskAssignmentInput(
              assignments: assignments,
              assignmentOptions: assignmentOptions,
              onChange: onAssignmentsChange,
            )
        ]));
  }
}
