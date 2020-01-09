import 'package:handball_flutter/enums.dart';
import 'package:meta/meta.dart';

class ParsedDueDate {
  final DueDateType type;
  final String text;

  ParsedDueDate({
    @required this.type,
    @required this.text,
  });
}

ParsedDueDate parseDueDate(bool isComplete, bool isCompleting, DateTime dueDate) {
  // Show completed state unless the Task isCompleting (Being Animated out).
  if (isComplete == true && isCompleting == false) { 
    return ParsedDueDate(
          type: DueDateType.complete,
          text: '',
        );
  }

  if (dueDate == null) {
    return ParsedDueDate(
      type: DueDateType.unset,
      text: '',
    );
  }

final now = DateTime.now();

  // Today
  if (
    dueDate.year == now.year &&
    dueDate.month == now.month &&
    dueDate.day == now.day
    ) {
      return ParsedDueDate(
        type: DueDateType.today,
        text: 'Today',
      );
  }

  // Tomorrow
  if (
    dueDate.year == now.year &&
    dueDate.month == now.month &&
    dueDate.day == now.day + 1
  ) {
    return ParsedDueDate(
      type: DueDateType.soon,
      text: '1d'
    );
  }

  // Overdue
  if (dueDate.isBefore(now)) {
    return ParsedDueDate(
      type: DueDateType.overdue,
      text: 'Due'
    );
  }

  // Later On
  final differenceInDays = dueDate.difference(now).inDays;

  if (differenceInDays >= 1 && differenceInDays <= 6) {
    return ParsedDueDate(
      type: DueDateType.later,
      text: '${differenceInDays + 1}d'
    );
  }

  // At least a week out
  if (differenceInDays >= 7) {
    return ParsedDueDate(
      type: DueDateType.later,
      text: '${(differenceInDays / 7).round()}w'
    );
  }

  return ParsedDueDate(
    type: DueDateType.unset,
    text: '',
  );
}