import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:intl/intl.dart';

class DateSelectListTile extends StatelessWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final String hintText;
  final bool enabled;
  final bool isClearable;
  final dynamic onChange;

  DateSelectListTile({
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
        leading: Icon(Icons.calendar_today),
        title: Text(_getDateText(initialDate)),
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
    var result = await showDatePicker(
      firstDate: firstDate,
      lastDate: lastDate,
      context: context,
      initialDate: initialDate ?? DateTime.now(),
    );

    if (result != null) {
      onChange(result);
    }
  }

  String _getDateText(DateTime date) {
    if (date == null) {
      return hintText ?? 'Pick date';
    }

    var formatter = new DateFormat('EEEE MMMM d');
    return formatter.format(date);
  }
}
