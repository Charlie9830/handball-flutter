import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';

class DueDateChit extends StatelessWidget {
  final DueDateType color;
  final String text;
  final DueDateChitSize size;
  final dynamic onTap;

  DueDateChit({
    this.color = DueDateType.complete,
    this.text = '',
    this.size = DueDateChitSize.standard,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size == DueDateChitSize.small ? 32 : 48,
      height: size == DueDateChitSize.small ? 32 : 48,
      padding: EdgeInsets.all(size == DueDateChitSize.small ? 4 : 8),
      child: Container(
          decoration: BoxDecoration(
            color: _getBackgroundColor(color, context),
            shape: BoxShape.circle,
          ),
          child: Center(
              child: Text(text,
                  style:
                      TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))),
    );
  }

  Color _getBackgroundColor(DueDateType type, BuildContext context) {
    switch (type) {
      case DueDateType.later:
        return Colors.green;
        break;

      case DueDateType.soon:
        return Colors.deepOrange;
        break;

      case DueDateType.today:
        return Colors.blue;
        break;

      case DueDateType.overdue:
        return Colors.red;
        break;

      case DueDateType.complete:
        return Colors.transparent;
        break;

      case DueDateType.unset:
        return Colors.transparent;
        break;

      default:
        return Colors.transparent;
        break;
    }
  }
}
