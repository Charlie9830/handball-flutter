import 'package:flutter/material.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/presentation/ListEntryExitAnimation.dart';
import 'package:sticky_headers/sticky_headers.dart';

class TaskList extends StatefulWidget {
  final String uid;
  final Widget header;
  final List<Widget> children;
  final onTap;
  final bool isFocused;

  TaskList({
    this.uid,
    this.header,
    this.children,
    this.onTap,
    this.isFocused,
  });

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    if (taskListAnimatedListStateKeys[widget.uid] == null) {
      taskListAnimatedListStateKeys[widget.uid] =
          GlobalKey<AnimatedListState>();
    }

    return new StickyHeader(
        header: widget.header,
        content: AnimatedList(
            key: taskListAnimatedListStateKeys[widget.uid],
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            initialItemCount: widget.children.length,
            itemBuilder: (context, index, animation) {
              return ListEntryExitAnimation(
                key: widget.children[index].key,
                animation: animation,
                child: widget.children[index],
              );
            }));
  }

  @override
  void dispose() {
    print('Disposing ${widget.uid}');
    taskListAnimatedListStateKeys.remove(widget.uid);
    super.dispose();
  }
}
