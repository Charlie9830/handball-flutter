import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/presentation/Nothing.dart';
import 'package:sticky_headers/sticky_headers.dart';

class TaskList extends StatelessWidget {
  final String uid;
  final Widget header;
  final List<Widget> children;
  final onTap;
  bool isFocused;

  TaskList({
    this.uid,
    this.header,
    this.children,
    this.onTap,
    this.isFocused,
  });

  @override
  Widget build(BuildContext context) {
    if (taskListAnimatedListStateKeys[uid] == null) {
      taskListAnimatedListStateKeys[uid] = GlobalKey<AnimatedListState>();
    }

    return new StickyHeader(
      header: header,
      content: AnimatedList(
        key: taskListAnimatedListStateKeys[uid],
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        initialItemCount: children.length,
        itemBuilder: (context, index, animation) {
          return SizeTransition(
            sizeFactor: animation,
            child: children[index],
            axis: Axis.vertical,
          );
        }
      )
    );
  }
}
