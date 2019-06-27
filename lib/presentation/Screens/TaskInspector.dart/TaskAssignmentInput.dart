import 'package:flutter/material.dart';
import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/presentation/Dialogs/ChooseAssignmentDialog/ChooseAssignmentDialog.dart';

class TaskAssignmentInput extends StatelessWidget {
  final List<Assignment> assignments;
  final List<Assignment> assignmentOptions;
  final dynamic onChange;
  const TaskAssignmentInput(
      {Key key, this.assignments, this.assignmentOptions, this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.people),
      title: _getTitleWidget(context),
      onTap: () => _handleTap(context),
    );
  }

  void _handleTap(BuildContext context) async {
    var result = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => ChooseAssignmentDialog(
              initialAssignedOptions: assignments,
              options: assignmentOptions,
            ));

    if (result == null) {
      return;
    }

    if (result is List<String>) {
      onChange(result);
    }
  }

  Widget _getTitleWidget(BuildContext context) {
    if (assignments == null || assignments.length == 0) {
      return Text('Assign to');
    } else {
      return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _mapAssignments(context));
    }
  }

  Iterable<Widget> _mapAssignments(BuildContext context) {
    int count = 0;
    int maxCount = 2;
    var widgets = <Widget>[];

    for (var assignment in assignments) {
      widgets.add(Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Text(assignment.displayName),
      ));

      count++;

      if (count == maxCount) {
        // Truncate and Break.
        var overflow = assignments.length - count;
        if (overflow > 0) {
          widgets.add(Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              '${assignments.length - count} more',
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.end,
            ),
          ));
        }
        break;
      }
    }

    return widgets;
  }
}
