import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
    this.type = ActivityFeedEventType.values[doc['type']];
    this.timestamp = coerceFirestoreTimestamp(doc['timestamp']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'originUserId': this.originUserId,
      'projectId': this.projectId,
      'projectName': this.projectName,
      'title': this.title,
      'selfDescription': this.selfTitle,
      'details': this.details,
      'type': this.type.index,
      'timestamp': this.timestamp == null ? '' : Timestamp.fromDate(this.timestamp),
    };
  }

  int get daysSinceEpoch {
    return this.timestamp.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays;
  }
}