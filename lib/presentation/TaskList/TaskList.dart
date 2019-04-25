import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  final Widget header;
  final List<Widget> children;

  TaskList({this.header, this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          header,
          Column(
            children: children,
          )
        ],
        )
    );
  }
}