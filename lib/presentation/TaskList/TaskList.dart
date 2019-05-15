import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class TaskList extends StatelessWidget {
  final Widget header;
  final List<Widget> children;
  final onTap;
  bool isFocused;

  TaskList({
    this.header,
    this.children,
    this.onTap,
    this.isFocused,
  });

  @override
  Widget build(BuildContext context) {
    return new StickyHeader(
      header: header,
      content: Column(
        children: children,
      )
    );
  }

  // var backgroundColor = isFocused
  //       ? Theme.of(context).colorScheme.surface
  //       : Theme.of(context).colorScheme.background;

    // return Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: GestureDetector(
    //       onTap: onTap,
    //       child: Container(
    //           child: Column(
    //             children: <Widget>[
    //               header,
    //               Column(
    //                 children: children,
    //               )
    //             ],
    //           ),
    //           color: backgroundColor)),
    // );
}
