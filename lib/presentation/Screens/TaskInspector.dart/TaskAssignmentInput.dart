import 'package:flutter/material.dart';
import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/presentation/Dialogs/ChooseAssignmentDialog/ChooseAssignmentDialog.dart';
import 'package:handball_flutter/presentation/ReactiveAnimatedList.dart';

class TaskAssignmentInput extends StatelessWidget {
  final List<Assignment> assignments;
  final List<Assignment> assignmentOptions;
  final bool clearOnly;
  final dynamic onChange;
  const TaskAssignmentInput(
      {Key key,
      this.assignments,
      this.clearOnly,
      this.assignmentOptions,
      this.onChange})
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
    if (clearOnly == true) {
      onChange(<String>[]);
      return;
    }

    final result = await showDialog(
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
    if (assignments == null || assignments.isEmpty) {
      return Text('Assign to');
    }

    if (clearOnly == true) {
      final plural = assignments.length > 1 ? 's' : '';
      return Text('Clear Assignment$plural');
    }
    
     else {
      return ReactiveAnimatedList(
          shrinkWrap: true, children: _mapAssignments(context));
    }
  }

  Iterable<Widget> _mapAssignments(BuildContext context) {
    int count = 0;
    int maxCount = 2;
    var widgets = <Widget>[];

    for (var assignment in assignments) {
      widgets.add(Padding(
          key: Key(assignment.userId),
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(assignment.displayName),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => _handleAssignmentClear(assignment.userId),
                )
              ])));

      count++;

      if (count == maxCount) {
        // Truncate and Break.
        var overflow = assignments.length - count;
        if (overflow > 0) {
          widgets.add(Padding(
            key: Key('overflow-indicator'),
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

  void _handleAssignmentClear(String userId) {
    var assignmentIds =
        assignments.map((assignment) => assignment.userId).toList();

    assignmentIds.remove(userId);

    onChange(assignmentIds);
  }
}
