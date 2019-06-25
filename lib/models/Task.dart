import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/models/Comment.dart';
import 'package:handball_flutter/models/TaskMetadata.dart';
import 'package:handball_flutter/utilities/coerceDate.dart';
import 'package:handball_flutter/utilities/normalizeDate.dart';
import 'package:meta/meta.dart';

class TaskModel {
  String uid;
  String project;
  String taskList;
  String taskName;
  String userId; // Not the user ID of the creator.
  DateTime dueDate;
  DateTime dateAdded;
  bool isComplete;
  bool isHighPriority;
  String note;
  String assignedTo;
  List<CommentModel> commentPreview;
  Map<String, String> unseenTaskCommentMembers;
  TaskMetadata metadata;
  /* 
    UPDATE THE copyWith METHOD BELOW
  */

  TaskModel({
    @required this.uid,
    @required this.project,
    @required this.taskList,
    @required this.userId,
    @required this.metadata,
    this.taskName = '',
    this.dueDate,
    this.dateAdded,
    this.isComplete = false,
    this.note = '',
    this.assignedTo = '-1',
    this.isHighPriority = false,
    this.commentPreview,
    this.unseenTaskCommentMembers,
  });

  TaskModel.fromDoc(DocumentSnapshot doc, String userId) {
    this.uid = doc['uid'];
    this.project = doc['project'];
    this.taskList = doc['taskList'];
    this.userId = userId;
    this.taskName = doc['taskName'] ?? '';
    this.dueDate = _coerceDueDate(doc['dueDate']);
    this.dateAdded = coerceDate(doc['dateAdded']);
    this.isComplete = doc['isComplete'] ?? false;
    this.note = doc['note'] ?? '';
    this.isHighPriority = doc['isHighPriority'] ?? false;
    this.assignedTo = doc['assignedTo'] ?? '-1';
    this.commentPreview = _coerceCommentPreview(doc['commentPreview'], doc.metadata.isFromCache);
    this.unseenTaskCommentMembers = _coerceUnseenTaskCommentMembers(doc['unseenTaskCommentMembers']);
    this.metadata = TaskMetadata.fromMap(doc['metadata']);
  }
  
  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'project': this.project,
      'taskList': this.taskList,
      'taskName': this.taskName,
      'dueDate': this.dueDate == null
          ? ''
          : normalizeDate(this.dueDate).toIso8601String(),
      'dateAdded':
          this.dateAdded == null ? '' : this.dateAdded.toIso8601String(),
      'isComplete': this.isComplete,
      'note': this.note,
      'isHighPriority': this.isHighPriority,
      'assignedTo': this.assignedTo,
      'commentPreview': _convertCommentPreviewToMapCollection(),
      'unseenTaskCommentMembers': this.unseenTaskCommentMembers ?? <String, dynamic>{},
      'metadata' : this.metadata?.toMap() ?? <dynamic, dynamic>{},
    };
  }

  bool get hasUnseenComments {
    return this.unseenTaskCommentMembers[this.userId] != null;
  }

  TaskModel copyWith({
  String uid,
  String project,
  String taskList,
  String taskName,
  String userId,
  DateTime dueDate,
  DateTime dateAdded,
  bool isComplete,
  bool isHighPriority,
  String note,
  String assignedTo,
  List<CommentModel> commentPreview,
  Map<String, String> unseenTaskCommentMembers,
  TaskMetadata metadata,
  }) {
    return TaskModel(
      uid: uid ?? this.uid,
      userId: userId ?? this.userId,
      project: project ?? this.project,
      taskList: taskList ?? this.taskList,
      taskName: taskName ?? this.taskName,
      dueDate: dueDate ?? this.dueDate,
      dateAdded: dateAdded ?? this.dateAdded,
      isComplete: isComplete ?? this.isComplete,
      isHighPriority: isHighPriority ?? this.isHighPriority,
      note: note ?? this.note,
      assignedTo: assignedTo ?? this.assignedTo,
      commentPreview: commentPreview ?? this.commentPreview,
      unseenTaskCommentMembers: unseenTaskCommentMembers ?? this.unseenTaskCommentMembers,
      metadata: metadata ?? this.metadata
    );
  }

  Map<String, String> _coerceUnseenTaskCommentMembers(Map<dynamic, dynamic> unseenTaskCommentMembers) {
    if (unseenTaskCommentMembers == null) {
      return <String,String>{};
    }

    return Map<String, String>.from(unseenTaskCommentMembers);
  }

  List<Map<String,dynamic>> _convertCommentPreviewToMapCollection() {
    if (commentPreview == null || commentPreview.length == 0) {
      return <Map<String,dynamic>>[];
    }

    return commentPreview.map( (comment) => comment.toMap()).toList();
  }

  List<CommentModel> _coerceCommentPreview(List<dynamic> commentPreview, bool isFromCache) {
    if (commentPreview == null || commentPreview.length == 0) {
      return <CommentModel>[];
    }

    return commentPreview.map( (comment) => CommentModel.fromMap(comment, isFromCache)).toList();
  }

  DateTime _coerceDueDate(String dueDate) {
    DateTime dirtyDueDate = dueDate == '' ? null : DateTime.parse(dueDate);

    if (dirtyDueDate == null) {
      return null;
    }

    return normalizeDate(dirtyDueDate);
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
