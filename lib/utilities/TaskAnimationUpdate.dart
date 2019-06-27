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

  static int removalSorter(TaskAnimationUpdate a, TaskAnimationUpdate b) {
    int hashCodeA = a.listStateKey?.hashCode ?? 0;
    int hashCodeB = b.listStateKey?.hashCode ?? 0;

    if (hashCodeA < hashCodeB) {
      return 1;
    }

    if (hashCodeA > hashCodeB) {
      return -1;
    } 
    
    else {
      // Null Indexes get handled later. For now lets just put them somwhere in the sort order.
      int indexA = a.index ?? 0;
      int indexB = b.index ?? 0;

      return indexB - indexA;
    }
  }

  static int additionSorter(TaskAnimationUpdate a, TaskAnimationUpdate b) {
    int hashCodeA = a.listStateKey?.hashCode ?? 0;
    int hashCodeB = b.listStateKey?.hashCode ?? 0;

    if (hashCodeA < hashCodeB) {
      return 1;
    }

    if (hashCodeA > hashCodeB) {
      return -1;
    } else {
      // Null Indexes get handled later. For now lets just put them somwhere in the sort order.
      int indexA = a.index ?? 0;
      int indexB = b.index ?? 0;

      return indexA - indexB;
    }
  }
}
