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
      children: _getChildren(context),
    );
  }

  List<Widget> _getChildren(BuildContext context) {
    if (assignments == null) {
      return <Widget>[];
    }

    var backgroundColor = Theme.of(context).brightness == Brightness.light ? Colors.grey : Colors.blueGrey;
    
    return assignments.map( (item) {
      return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        padding: EdgeInsets.all(4),
        child: Text(item.displayName, style: TextStyle(color: Colors.white /*colorPair.textColor*/)),
      );
    }).toList();
  }
}