import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/utilities/normalizeDate.dart';
import 'package:meta/meta.dart';

class TaskModel {
  String uid;
  String project;
  String taskList;
  String taskName;
  DateTime dueDate;
  DateTime dateAdded;
  bool isComplete;
  bool isHighPriority;
  String note;
  String assignedTo;

  TaskModel(
      {@required this.uid,
      @required this.project,
      @required this.taskList,
      this.taskName = '',
      this.dueDate,
      this.dateAdded,
      this.isComplete = false,
      this.note = '',
      this.assignedTo = '-1',
      this.isHighPriority = false,
      });

  TaskModel.fromDoc(DocumentSnapshot doc) {
    this.uid = doc['uid'];
    this.project = doc['project'];
    this.taskList = doc['taskList'];
    this.taskName = doc['taskName'] ?? '';
    this.dueDate = _coerceDueDate(doc['dueDate']);
    this.dateAdded = _coerceDateAdded(doc['dateAdded']);
    this.isComplete = doc['isComplete'] ?? false;
    this.note = doc['note'] ?? '';
    this.isHighPriority = doc['isHighPriority'] ?? false;
    this.assignedTo = doc['assignedTo'] ?? '-1';
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'project': this.project,
      'taskList': this.taskList,
      'taskName': this.taskName,
      'dueDate': this.dueDate == null ? '' : normalizeDate(this.dueDate).toIso8601String(),
      'dateAdded': this.dateAdded == null ? '' : this.dateAdded.toIso8601String(),
      'isComplete': this.isComplete,
      'note': this.note,
      'isHighPriority': this.isHighPriority,
      'assignedTo': this.assignedTo,
    };
  }

  

  DateTime _coerceDueDate(String dueDate) {
    DateTime dirtyDueDate = dueDate == '' ? null : DateTime.parse(dueDate);

    if (dirtyDueDate == null) {
      return null;
    }

    return normalizeDate(dirtyDueDate);
  }

  DateTime _coerceDateAdded(String dateAdded) {
      return dateAdded == null || dateAdded == '' ? null : DateTime.parse(dateAdded);
  }
}

class TaskViewModel {
  final dynamic onSelect;
  final dynamic onCheckboxChanged;
  final dynamic onDelete;
  final dynamic onTaskInspectorOpen;

  bool get hasNote {
    return data.note.trim().isNotEmpty;
  } 

  TaskModel data;

  TaskViewModel({
      @required this.data,
      this.onSelect,
      this.onCheckboxChanged,
      this.onDelete,
      this.onTaskInspectorOpen,
      });
}
