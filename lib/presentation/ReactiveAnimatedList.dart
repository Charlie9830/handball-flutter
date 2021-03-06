import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/ListEntryExitAnimation.dart';
import 'package:handball_flutter/presentation/Nothing.dart';

class ReactiveAnimatedList extends StatefulWidget {
  final List<Widget> children;
  final ScrollPhysics physics;
  final bool shrinkWrap;
  final ScrollController controller;
  ReactiveAnimatedList(
      {Key key,
      this.children,
      this.physics,
      this.shrinkWrap = false,
      this.controller})
      : super(key: key);

  _ReactiveAnimatedListState createState() => _ReactiveAnimatedListState();
}

class _ReactiveAnimatedListState extends State<ReactiveAnimatedList> {
  GlobalKey<AnimatedListState> listStateKey;

  @override
  void initState() {
    super.initState();

    listStateKey = GlobalKey<AnimatedListState>();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (listStateKey?.currentState == null) {
      return;
    }

    if (oldWidget is ReactiveAnimatedList) {
      var diffedChildren = diffChildren(
          newCollection: widget.children, oldCollection: oldWidget.children);

      for (var index in diffedChildren.addedIndexes) {
        listStateKey.currentState.insertItem(index);
      }

      for (var index in diffedChildren.removedIndexes) {
        listStateKey.currentState.removeItem(
            index,
            (context, animation) => ListEntryExitAnimation(
                key: oldWidget.children[index].key,
                animation: animation,
                child: oldWidget.children[index]),
            duration: Duration(milliseconds: 150));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
        controller: widget.controller,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        key: listStateKey,
        initialItemCount: widget.children.length,
        itemBuilder: (context, index, animation) {
          if (index >= widget.children.length) {
            return Nothing();
          }

          return ListEntryExitAnimation(
            key: widget.children[index].key,
            child: widget.children[index],
            animation: animation,
          );
        });
  }
}

class WidgetCollectionDiff {
  final List<int> addedIndexes;
  final List<int> removedIndexes;

  WidgetCollectionDiff({
    this.addedIndexes,
    this.removedIndexes,
  });
}

WidgetCollectionDiff diffChildren(
    {List<Widget> newCollection, List<Widget> oldCollection}) {
  var newIndexCounter = 0;
  var newSet = newCollection
      .map((widget) => WidgetWrapper(
          widget: widget, key: widget.key, index: newIndexCounter++))
      .toSet();

  var oldIndexCounter = 0;
  var oldSet = oldCollection
      .map((widget) => WidgetWrapper(
          widget: widget, key: widget.key, index: oldIndexCounter++))
      .toSet();

  var addedIndexes = newSet
      .difference(oldSet)
      .map((item) => item.index)
      .toList()
        ..sort((a, b) => a - b);
  var removedIndexes = oldSet
      .difference(newSet)
      .map((item) => item.index)
      .toList()
        ..sort((a, b) => b - a);

  return WidgetCollectionDiff(
    addedIndexes: addedIndexes,
    removedIndexes: removedIndexes,
  );
}

class WidgetWrapper {
  final Widget widget;
  final Key key;
  final int index;

  WidgetWrapper({
    this.widget,
    this.key,
    this.index,
  });

  @override
  bool operator ==(dynamic other) {
    if (other is WidgetWrapper) {
      return other.key == this.key;
    }

    return false;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}
