import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:intl/intl.dart';

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
        leading: Icon(Icons.alarm),
        title: Text(_getDateTimeText(initialDate)),
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
    var dateResult = await showDatePicker(
      firstDate: firstDate,
      lastDate: lastDate,
      context: context,
      initialDate: initialDate ?? DateTime.now(),
    );

    if (dateResult == null) {
      return;
    }

    var timeResult = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 12, minute: 0),
    );

    if (dateResult != null && timeResult != null) {
      var result = dateResult.subtract(Duration(hours: dateResult.hour, minutes: dateResult.minute, seconds: dateResult.second));
      result.add(Duration(hours: timeResult.hour, minutes: timeResult.minute));
      onChange(result);
    }
  }

  String _getDateTimeText(DateTime date) {
    print(date);
    if (date == null) {
      return hintText ?? 'Pick date';
    }

    var dateFormater = new DateFormat('EEEE MMMM d');
    var timeFormatter = new DateFormat('jm');
    return '${dateFormater.format(date)} at ${timeFormatter.format(date)}';
  }
}
