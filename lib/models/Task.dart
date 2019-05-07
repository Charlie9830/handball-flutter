import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class TaskModel {
  String uid;
  String project;
  String taskList;
  String taskName;
  DateTime dueDate;
  bool isComplete;

  TaskModel(
      {@required this.uid,
      @required this.project,
      @required this.taskList,
      this.taskName = '',
      this.dueDate,
      this.isComplete = false});

  TaskModel.fromDoc(DocumentSnapshot doc) {
    print(doc);
    this.uid = doc['uid'];
    this.project = doc['project'];
    this.taskList = doc['taskList'];
    this.taskName = doc['taskName'];
    this.dueDate = _coerceDueDate(doc['dueDate']);
    this.isComplete = doc['isComplete'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'project': this.project,
      'taskList': this.taskList,
      'taskName': this.taskName,
      'dueDate': this.dueDate == null ? '' : this.dueDate.toIso8601String(),
      'isComplete': this.isComplete,
    };
  }

  DateTime _coerceDueDate(String dueDate) {
    DateTime dirtyDueDate = dueDate == '' ? null : DateTime.parse(dueDate);

    if (dirtyDueDate == null) {
      return null;
    }

    return dirtyDueDate.subtract(Duration(hours: dirtyDueDate.hour - 1, minutes: dirtyDueDate.minute));
  }
}

class TaskViewModel {
  final dynamic onSelect;
  final dynamic onCheckboxChanged;
  final dynamic onDelete;
  final dynamic onTaskInspectorOpen;

  TaskModel data;

  TaskViewModel(
      {@required this.data,
      this.onSelect,
      this.onCheckboxChanged,
      this.onDelete,
      this.onTaskInspectorOpen});
}
