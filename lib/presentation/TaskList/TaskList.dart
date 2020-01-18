import 'package:flutter/material.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/presentation/ListEntryExitAnimation.dart';
import 'package:handball_flutter/presentation/Nothing.dart';
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
              if (index >= widget.children.length) {
                // Welcome back. The AnimatedTask System broke again didn't it?. You are probably wondering why you return
                // a Nothing Widget here instead of throwing an out of range exception.
                // It's because dispatching a sync action to the Redux store doesn't actually gaurantee Flutter will rebuild. 
                // This means that this builder could be getting called on stale data.
                // More info in the issue you posted about it to Flutter_Redux here.
                // https://github.com/brianegan/flutter_redux/issues/165
                return Nothing();
              }

              return ListEntryExitAnimation(
                key: widget.children[index].key,
                animation: animation,
                child: widget.children[index],
              );
            }));
  }

  @override
  void dispose() {
    taskListAnimatedListStateKeys.remove(widget.uid);
    super.dispose();
  }
}
