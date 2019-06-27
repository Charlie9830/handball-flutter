import 'package:flutter/material.dart';
import 'package:handball_flutter/models/Task.dart';

class TaskAnimationUpdate {
  TaskModel task;
  int index;
  GlobalKey<AnimatedListState> listStateKey;

  TaskAnimationUpdate({
    this.task,
    this.index,
    this.listStateKey,
  });

  static int removalSorter( TaskAnimationUpdate a, TaskAnimationUpdate b ) {
    if (a.listStateKey.hashCode < b.listStateKey.hashCode) {
      return 1;
    }

    if (a.listStateKey.hashCode > b.listStateKey.hashCode) {
      return -1;
    }

    else {
      return b.index - a.index;
    }
  }

  static int additionSorter( TaskAnimationUpdate a, TaskAnimationUpdate b ) {
    if (a.listStateKey.hashCode < b.listStateKey.hashCode) {
      return 1;
    }

    if (a.listStateKey.hashCode > b.listStateKey.hashCode) {
      return -1;
    }

    else {
      return a.index - b.index;
    }
  }
}

