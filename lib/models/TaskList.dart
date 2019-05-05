import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:meta/meta.dart';

class TaskListModel {
  String uid;
  String project;
  String taskListName;

  TaskListModel({
    @required this.uid,
    @required this.project,
    this.taskListName = '',
  });

  TaskListModel.fromDoc(DocumentSnapshot doc) {
    print("Constructing");
    this.uid = doc['uid'];
    this.project = doc['project'];
    this.taskListName = doc['taskListName'];
  }

  Map<String,dynamic> toMap() {
    return {
      'uid': this.uid,
      'project': this.project,
      'taskListName': this.taskListName,
    };
  }
}

class TaskListViewModel {

  TaskListModel data;
  List<TaskViewModel> childTaskViewModels = [];
  bool isFocused;
  final onDelete;
  final onRename;

  final onTaskListFocus;

  TaskListViewModel({
    this.data,
    this.onTaskListFocus,
    this.isFocused,
    this.onDelete,
    this.onRename,
    });
}