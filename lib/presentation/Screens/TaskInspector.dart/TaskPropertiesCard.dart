import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/presentation/DateSelectListTile.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/ReminderSelectListTile.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/NoteInputListItem.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/TaskAssignmentInput.dart';

class TaskPropertiesCard extends StatelessWidget {
  final DateTime dueDate;
  final String note;
  final String taskName;
  final TaskInspectorAssignmentInputType assignmentInputType;
  final bool enableReminder;
  final DateTime reminder;
  final List<Assignment> assignments;
  final List<Assignment> assignmentOptions;
  final dynamic onDueDateChange;
  final dynamic onNoteChange;
  final dynamic onAssignmentsChange;
  final dynamic onReminderChange;

  TaskPropertiesCard({
    this.dueDate,
    this.onDueDateChange,
    this.note,
    this.reminder,
    this.enableReminder,
    this.assignmentInputType,
    this.assignmentOptions,
    this.assignments,
    this.onNoteChange,
    this.taskName,
    this.onAssignmentsChange,
    this.onReminderChange,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Theme.of(context).cardColor,
        child: Column(children: <Widget>[
          DateSelectListTile(
            firstDate: DateTime.now().subtract(Duration(days: 360)),
            lastDate: DateTime.now().add(Duration(days: 360)),
            initialDate: dueDate,
            onChange: onDueDateChange,
            hintText: 'Pick due date',
          ),
            ReminderSelectListTile(
              enabled: enableReminder,
              firstDate: DateTime.now().subtract(Duration(days: 1)),
              lastDate: DateTime.now().add(Duration(days: 360)),
              hintText: 'Set a reminder',
              isClearable: true,
              initialDate: reminder,
              onChange: onReminderChange,
            ),
          NoteInputListItem(
            note: note,
            onChange: onNoteChange,
            taskName: taskName,
          ),
          if (assignmentInputType != TaskInspectorAssignmentInputType.hidden)
            TaskAssignmentInput(
                assignments: assignments,
                assignmentOptions: assignmentOptions,
                clearOnly: assignmentInputType == TaskInspectorAssignmentInputType.clearOnly,
                onChange: onAssignmentsChange,
              )
        ]));
  }
}
