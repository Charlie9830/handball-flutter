import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:intl/intl.dart';

class DueDateListItem extends StatelessWidget {
  final DateTime dueDate;
  final dynamic onDueDateChange;

  DueDateListItem({
    this.dueDate,
    this.onDueDateChange,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.calendar_today),
        title: Text(_getDueDateText(dueDate)),
        trailing: PredicateBuilder(
          predicate: () => dueDate != null,
          childIfTrue: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => onDueDateChange(null),
          ),
          childIfFalse: SizedBox(height: 0, width: 0)
        ),
        onTap: () => handleTap(context));
  }

  void handleTap(BuildContext context) async {
    var result = await showDatePicker(
      firstDate: DateTime.now().subtract(Duration(days: 360)),
      lastDate: DateTime.now().add(Duration(days: 360)),
      context: context,
      initialDate: dueDate == null ? DateTime.now() : dueDate,
    );

    if (result != null) {
      print(result.toIso8601String());
      onDueDateChange(result);
    }
  }

  String _getDueDateText(DateTime dueDate) {
    if (dueDate == null) {
      return "Add due date";
    }

    var formatter = new DateFormat('EEEE MMMM d');
    return formatter.format(dueDate);
  }
}
