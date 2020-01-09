import 'package:flutter/material.dart';

class ListEntryExitAnimation extends StatelessWidget {
  final Key key;
  final Animation<double> animation;
  final Widget child;

  const ListEntryExitAnimation({
    this.key,
    this.animation,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
            parent: animation,
            curve: Interval(0, 0.5, curve: Curves.easeInCubic))),
        axis: Axis.vertical,
        child: FadeTransition(
          opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
              parent: animation,
              curve: Interval(0.5, 1, curve: Curves.easeOutCubic))),
          child: child,
        ));
  }
}
