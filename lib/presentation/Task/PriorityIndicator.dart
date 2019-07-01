import 'package:flutter/material.dart';

class PriorityIndicator extends StatelessWidget {
  final bool isHighPriority;

  const PriorityIndicator({
    Key key,
    this.isHighPriority,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2, top: 2),
      child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          child: SizedBox(
              width: isHighPriority == true ? 12 : 0,
              child: Container(color: Colors.orange))),
    );
  }
}
