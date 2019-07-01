import 'package:flutter/material.dart';
import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/presentation/Dialogs/ChooseAssignmentDialog/ChooseAssignmentDialog.dart';

class AssignmentShortcutChip extends StatelessWidget {
  final List<Assignment> assignments;
  final List<Assignment> assignmentOptions;
  final dynamic onChanged;
  final EdgeInsetsGeometry padding;

  AssignmentShortcutChip(
      {Key key, this.assignmentOptions, this.assignments, this.onChanged, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      padding: padding,
      avatar: Icon(
        Icons.people,
        size: 18,
      ),
      label: Text(_getLabelText()),
      onPressed: () => _handleTap(context),
    );
  }

  String _getLabelText() {
    if (assignments.length == 0) {
      return 'Assign to';
    }

    if (assignments.length == 1) {
      return assignments.first.displayName;
    }

    if (assignments.length > 1) {
      return assignments.first.displayName + '...';
    }

    return '';
  }

  void _handleTap(BuildContext context) async {
    var result = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return ChooseAssignmentDialog(
            initialAssignedOptions: assignments,
            options: assignmentOptions,
          );
        });

    if (result == null) {
      return;
    }

    onChanged(result);
  }
}
