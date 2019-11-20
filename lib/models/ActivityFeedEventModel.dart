import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/utilities/coerceFirestoreTimestamp.dart';

import '../enums.dart';

class ActivityFeedEventModel {
  String uid;
  String originUserId;
  String projectId;
  String projectName;
  String title;
  String selfTitle;
  String details;
  List<Assignment> assignments;
  ActivityFeedEventType type;
  DateTime timestamp;

  ActivityFeedEventModel({
    @required this.uid,
    @required this.originUserId,
    @required this.projectId,
    @required this.projectName,
    @required this.title,
    @required this.selfTitle,
    @required this.details,
    @required this.type,
    this.assignments,
    @required this.timestamp,
  });

  ActivityFeedEventModel.fromDoc(DocumentSnapshot doc) {
    this.uid = doc['uid'];
    this.originUserId = doc['originUserId'];
    this.projectId = doc['projectId'];
    this.projectName = doc['projectName'];
    this.title = doc['title'];
    this.selfTitle = doc['selfDescription'];
    this.details = doc['details'];
    this.assignments = _coerceAssignments(doc['assignments']);
    this.type = ActivityFeedEventType.values[doc['type']];
    this.timestamp = coerceFirestoreTimestamp(doc['timestamp']);
  }

  Map<String, dynamic> toMap() {
    var preCoercedAssignments = this.assignments ?? <Assignment>[];

    return {
      'uid': this.uid,
      'originUserId': this.originUserId,
      'projectId': this.projectId,
      'projectName': this.projectName,
      'title': this.title,
      'selfDescription': this.selfTitle,
      'details': this.details,
      'type': this.type.index,
      'assignments': preCoercedAssignments.map((item) => item.toMap()).toList(),
      'timestamp': this.timestamp == null ? '' : Timestamp.fromDate(this.timestamp),
    };
  }

  List<Assignment> _coerceAssignments(List<dynamic> values) {
    if (values == null) {
      return <Assignment>[];
    }

    return values.map((item) => Assignment.fromMap(item)).toList();
  }

  int get daysSinceEpoch {
    return this.timestamp.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays;
  }

  bool isAssignedToSelf(String userId) {
    return this.assignments.any((item) => item.userId == userId);
  }
}