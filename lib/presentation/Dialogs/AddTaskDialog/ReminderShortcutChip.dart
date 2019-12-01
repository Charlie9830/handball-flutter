import 'package:flutter/material.dart';
import 'package:handball_flutter/utilities/getDateTimeText.dart';
import 'package:handball_flutter/utilities/showReminderPicker.dart';

class ReminderShortcutChip extends StatefulWidget {
  final DateTime reminderTime;
  final EdgeInsets padding;
  final onChanged;

  ReminderShortcutChip({
    this.reminderTime,
    this.padding,
    this.onChanged,
  });

  @override
  _ReminderShortcutChipState createState() => _ReminderShortcutChipState();
}

class _ReminderShortcutChipState extends State<ReminderShortcutChip> {
  GlobalKey _actionChipKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: ActionChip(
        key: _actionChipKey,
        avatar: Icon(
          Icons.notifications,
          size: 18,
        ),
        label: Text(getDateTimeText(widget.reminderTime, 'Reminder')),
        onPressed: () => _handlePressed(context),
      ),
    );
  }

  void _handlePressed(BuildContext context) async {
    var result = await showReminderPicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 360)),
      initialDate: widget.reminderTime,
    );

    if (result != null) {
      _submit(result);
    }
  }

  void _submit(DateTime date) {
    widget.onChanged(date);
  }
}
