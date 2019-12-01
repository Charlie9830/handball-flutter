import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/utilities/getDateTimeText.dart';
import 'package:handball_flutter/utilities/showReminderPicker.dart';

class ReminderSelectListTile extends StatelessWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String hintText;
  final bool enabled;
  final bool isClearable;
  final dynamic onChange;

  ReminderSelectListTile({
    this.initialDate,
    this.enabled = true,
    this.isClearable = true,
    this.hintText,
    this.firstDate,
    this.lastDate,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        enabled: enabled,
        leading: Icon(Icons.notifications),
        title: Text(getDateTimeText(initialDate, 'Reminder')),
        trailing: PredicateBuilder(
          predicate: () => initialDate != null && isClearable == true,
          childIfTrue: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => onChange(null),
          ),
          childIfFalse: SizedBox(height: 0, width: 0)
        ),
        onTap: () => handleTap(context));
  }

  void handleTap(BuildContext context) async {
    var result = await showReminderPicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: initialDate,
    );

    if (result != null) {
      onChange(result);
    }
  }

}
