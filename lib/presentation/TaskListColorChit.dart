import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Nothing.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';

class TaskListColorChit extends StatelessWidget {
  final Color color;
  const TaskListColorChit({Key key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PredicateBuilder(
      predicate: () => color != null,
      childIfTrue: Container(
      alignment: Alignment.center,
      width: 16,
      height: 48,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    ),
    childIfFalse: Nothing()
    );
  }
}