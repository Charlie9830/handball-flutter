import 'package:flutter/material.dart';
import 'package:handball_flutter/utilities/getPositionFromGlobalKey.dart';
import 'package:intl/intl.dart';

class DueDateShortcutChip extends StatefulWidget {
  final DateTime dueDate;
  EdgeInsets padding;
  final onChanged;

  DueDateShortcutChip({
    this.dueDate,
    this.padding,
    this.onChanged,
  });

  @override
  _DueDateShortcutChipState createState() => _DueDateShortcutChipState();
}

class _DueDateShortcutChipState extends State<DueDateShortcutChip> {
  GlobalKey _actionChipKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: ActionChip(
        key: _actionChipKey,
        avatar: Icon(
          Icons.calendar_today,
          size: 18,
        ),
        label: Text(_parseDueDate(widget.dueDate)),
        onPressed: () => _handlePressed(context),
      ),
    );
  }

  void _handlePressed(BuildContext context) async {
    var position = getPositionFromGlobalKey(_actionChipKey);

    var result = await showMenu(
        position: RelativeRect.fromLTRB(0, position.top - 48, position.right, 0),
        context: context,
        items: <PopupMenuEntry>[
          PopupMenuItem(
            value: 'today',
            child: Text('Today'),
          ),
          PopupMenuItem(
            value: 'tomorrow',
            child: Text('Tomorrow'),
          ),
          PopupMenuItem(value: 'custom', child: Text('Pick a date'))
        ]);

    if (result == 'today') {
      _submit(DateTime.now());
    }

    if (result == 'tomorrow') {
      _submit(DateTime.now().add(Duration(days: 1)));
    }

    if (result == 'custom') {
      var datePickerResult = await showDatePicker(
        firstDate: DateTime.now().subtract(Duration(days: 360)),
        lastDate: DateTime.now().add(Duration(days: 360)),
        initialDate: DateTime.now(),
        context: context,
      );

      _submit(datePickerResult);
    }
  }

  void _submit(DateTime date) {
    widget.onChanged(date);
  }

  String _parseDueDate(DateTime dueDate) {
    if (dueDate == null) {
      return 'Add due date';
    }

    var now = DateTime.now();

    if (dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day) {
      return 'Today';
    }

    if (dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day + 1) {
      return 'Tomorrow';
    }

    var formatter = new DateFormat('MMMMEEEEd');
    return formatter.format(now);
  }
}
