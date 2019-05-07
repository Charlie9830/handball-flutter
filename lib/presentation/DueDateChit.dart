import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';

class DueDateChit extends StatelessWidget {
  final DueDateType color;
  final String text;
  final DueDateChitSize size;

  DueDateChit({
    this.color = DueDateType.complete,
    this.text = '',
    this.size = DueDateChitSize.standard,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 48,
        height: 48,
        padding: EdgeInsets.all(8),
        child: Container(
            width: _getWidth(size),
            height: _getHeight(size),
            decoration: BoxDecoration(
              color: _getBackgroundColor(color, context),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)))),
      ),
      onTap: () => print("Bloop"),
    );
  }

  double _getWidth(DueDateChitSize size) {
    switch (size) {
      case DueDateChitSize.small:
        return 24;
        break;

      case DueDateChitSize.standard:
        return 32;
        break;

      default:
        return 32;
        break;
    }
  }

  double _getHeight(DueDateChitSize size) {
    switch (size) {
      case DueDateChitSize.small:
        return 24;
        break;

      case DueDateChitSize.standard:
        return 32;
        break;

      default:
        return 32;
        break;
    }
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
        return Colors.grey;
        break;

      case DueDateType.unset:
        return Colors.grey;
        break;

      default:
        return Colors.grey;
        break;
    }
  }
}
