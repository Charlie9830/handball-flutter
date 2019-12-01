import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/models/Comment.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/Reminder.dart';
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
  List<CommentModel> commentPreview;
  Map<String, String> unseenTaskCommentMembers;
  TaskMetadata metadata;
  List<String> assignedTo;
  bool isDeleted;
  Map<String, ReminderModel> reminders;
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
    this.isHighPriority = false,
    this.commentPreview,
    this.unseenTaskCommentMembers,
    this.assignedTo = const <String>[],
    this.isDeleted = false,
    this.reminders,
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
    this.commentPreview =
        _coerceCommentPreview(doc['commentPreview'], doc.metadata.isFromCache);
    this.unseenTaskCommentMembers =
        _coerceUnseenTaskCommentMembers(doc['unseenTaskCommentMembers']);
    this.metadata = TaskMetadata.fromMap(doc['metadata']);
    this.assignedTo = _coerceAssignedTo(doc['assignedTo']);
    this.isDeleted = doc['isDeleted'] ?? false;
    this.reminders = _coerceReminders(doc['reminders']);
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
      'commentPreview': _convertCommentPreviewToMapCollection(),
      'unseenTaskCommentMembers':
          this.unseenTaskCommentMembers ?? <String, dynamic>{},
      'metadata': this.metadata?.toMap() ?? <dynamic, dynamic>{},
      'assignedTo': this.assignedTo ?? <String>[],
      'isDeleted': this.isDeleted,
      'reminders': _convertRemindersToMap(),
    };
  }

  ReminderModel get ownReminder {
    return this.reminders[this.userId];
  }

  bool get hasUnseenComments {
    return this.unseenTaskCommentMembers[this.userId] != null;
  }

  bool get isAssigned {
    return this.assignedTo != null && this.assignedTo.length > 0;
  }

  bool get isAssignedToSelf {
    return this.isAssigned && this.assignedTo.contains(this.userId);
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
    List<String> assignedTo,
    List<CommentModel> commentPreview,
    Map<String, String> unseenTaskCommentMembers,
    TaskMetadata metadata,
    bool isDeleted,
    Map<String, ReminderModel> reminders,
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
      unseenTaskCommentMembers:
          unseenTaskCommentMembers ?? this.unseenTaskCommentMembers,
      metadata: metadata ?? this.metadata,
      isDeleted: isDeleted ?? this.isDeleted,
      reminders: reminders ?? this.reminders,
    );
  }

  Map<dynamic, dynamic> _convertRemindersToMap() {
    if (this.reminders == null) {
      return {};
    }

    return this.reminders.map((key, value) => MapEntry(key, value.toMap()));
  }

  Map<String, ReminderModel> _coerceReminders(Map<dynamic, dynamic> map) {
    if (map == null) {
      return <String,ReminderModel>{};
    }

    return map.map<String, ReminderModel>((key, value) {
      return MapEntry<String, ReminderModel>( key as String, ReminderModel.fromMap(value));
    });

  }

  List<Assignment> getAssignments(
      Map<String, MemberModel> memberDisplayNameLookup) {
    if (assignedTo == null) {
      return <Assignment>[];
    }

    return assignedTo.map((id) {
      return Assignment(
        displayName: memberDisplayNameLookup[id]?.displayName ?? '',
        userId: id,
      );
    }).toList();
  }

  List<String> _coerceAssignedTo(dynamic assignedToValue) {
    if (assignedToValue == null) {
      return <String>[];
    }

    if (assignedToValue is String) {
      if (assignedToValue == '-1') {
        return <String>[];
      } else {
        return <String>[assignedToValue];
      }
    }

    if (assignedToValue is List<dynamic>) {
      return assignedToValue.map((id) => id as String).toList();
    }

    return <String>[];
  }

  Map<String, String> _coerceUnseenTaskCommentMembers(
      Map<dynamic, dynamic> unseenTaskCommentMembers) {
    if (unseenTaskCommentMembers == null) {
      return <String, String>{};
    }

    return Map<String, String>.from(unseenTaskCommentMembers);
  }

  List<Map<String, dynamic>> _convertCommentPreviewToMapCollection() {
    if (commentPreview == null || commentPreview.length == 0) {
      return <Map<String, dynamic>>[];
    }

    return commentPreview.map((comment) => comment.toMap()).toList();
  }

  List<CommentModel> _coerceCommentPreview(
      List<dynamic> commentPreview, bool isFromCache) {
    if (commentPreview == null || commentPreview.length == 0) {
      return <CommentModel>[];
    }

    return commentPreview
        .map((comment) => CommentModel.fromMap(comment, isFromCache))
        .toList();
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
  final bool isInMultiSelectMode;
  final bool isMultiSelected;
  final bool isAssigned;
  final List<Assignment> assignments;
  final dynamic onRadioChanged;
  final dynamic onCheckboxChanged;
  final dynamic onDelete;
  final dynamic onTap;
  final dynamic onMove;
  final dynamic onLongPress;

  bool get hasNote {
    return data.note.trim().isNotEmpty;
  }

  TaskModel data;

  TaskViewModel({
    @required this.data,
    this.assignments,
    this.isAssigned,
    this.isInMultiSelectMode = false,
    this.isMultiSelected = false,
    this.onRadioChanged,
    this.onCheckboxChanged,
    this.onDelete,
    this.onTap,
    this.onMove,
    this.onLongPress,
  });
}
