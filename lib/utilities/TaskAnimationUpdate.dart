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
    int hashCodeA = a.listStateKey?.hashCode ?? 0;
    int hashCodeB = b.listStateKey?.hashCode ?? 0;

    if (hashCodeA < hashCodeB) {
      return 1;
    }

    if (hashCodeA > hashCodeB) {
      return -1;
    }

    else {
      return b.index - a.index;
    }
  }

  static int additionSorter( TaskAnimationUpdate a, TaskAnimationUpdate b ) {
    int hashCodeA = a.listStateKey?.hashCode ?? 0;
    int hashCodeB = b.listStateKey?.hashCode ?? 0;

    if (hashCodeA < hashCodeB) {
      return 1;
    }

    if (hashCodeA > hashCodeB) {
      return -1;
    }

    if (a.index == null || b.index == null) {
      print('AN INDEX IS NULL');
    }

    else {
      return a.index - b.index;
    }
  }
}

