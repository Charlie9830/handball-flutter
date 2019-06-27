import 'package:flutter/material.dart';
import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/utilities/UserColor.dart';

class AssignmentIndicator extends StatelessWidget {
  final List<Assignment> assignments;
  const AssignmentIndicator({Key key, this.assignments}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 2,
      runSpacing: 2,
      direction: Axis.horizontal,
      children: _getChildren(),
    );
  }

  List<Widget> _getChildren() {
    return assignments.map( (item) {
      var colorPair = UserColor.getColorPair(item.userId);
      return Container(
        decoration: BoxDecoration(
          color: colorPair.backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        padding: EdgeInsets.all(4),
        child: Text(item.displayName, style: TextStyle(color: colorPair.textColor)),
      );
    }).toList();
  }
}