import 'package:flutter/material.dart';
import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/presentation/Dialogs/ChooseAssignmentDialog/AssignmentListItem.dart';

class ChooseAssignmentDialog extends StatefulWidget {
  final List<Assignment> options;
  final List<Assignment> initialAssignedOptions;

  ChooseAssignmentDialog({Key key, this.options, this.initialAssignedOptions})
      : super(key: key);

  _ChooseAssignmentDialogState createState() => _ChooseAssignmentDialogState();
}

class _ChooseAssignmentDialogState extends State<ChooseAssignmentDialog> {
  List<Assignment> _assignedOptions;

  @override
  void initState() {
    super.initState();

    _assignedOptions =
        widget.initialAssignedOptions?.toList() ?? <Assignment>[];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
            child: Container(
                child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Pick contributors',
                style: Theme.of(context).textTheme.headline),
            FlatButton(
              child: Text('Clear'),
              onPressed: () => _handleClear(context),
            )
          ],
        ),
        Expanded(
            child: ListView(
          children: _getOptions(),
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text('Okay'),
              onPressed: ()  => Navigator.of(context).pop(_assignedOptionIds.toList()),
              textColor: Theme.of(context).colorScheme.secondary,
            ),
          ],
        )
      ],
    ))));
  }

  void _handleClear(BuildContext context) {
    setState(() => _assignedOptions = <Assignment>[]);
  }

  Iterable<String> get _assignedOptionIds {
    return _assignedOptions.map((item) => item.userId);
  }

  List<Widget> _getOptions() {
    var sortedOptions = widget.options.toList()..sort( (a, b) => a.displayName.compareTo(b.displayName));

    var widgets = sortedOptions.map((item) {
      return AssignmentListItem(
        key: Key(item.userId),
        displayName: item.displayName,
        isAssigned: _assignedOptionIds.contains(item.userId),
        onChanged: (value) => _handleAssignmentChange(item, value),
      );
    }).toList();

    return widgets;
  }

  void _handleAssignmentChange(Assignment assignment, bool newValue) {
    if (newValue == true &&
        _assignedOptionIds.contains(assignment.userId) == false) {

       setState(
           () => _assignedOptions = _assignedOptions.toList()..add(assignment));
    }

    if (newValue == false && _assignedOptionIds.contains(assignment.userId)) {
      var index = _assignedOptions.indexWhere((item) => item.userId == assignment.userId);
      if (index != -1) {
        setState(() => _assignedOptions = _assignedOptions..removeAt(index));
      }
    }
  }
}
