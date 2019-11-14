import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:handball_flutter/utilities/coerceFirestoreTimestamp.dart';

class ActivityFeedEventModel {
  String uid;
  String originUserId;
  String projectId;
  String projectName;
  String description;
  String selfDescription;
  String details;
  DateTime timestamp;

  ActivityFeedEventModel({
    @required this.uid,
    @required this.originUserId,
    @required this.projectId,
    @required this.projectName,
    @required this.description,
    @required this.selfDescription,
    @required this.details,
    @required this.timestamp,
  });

  ActivityFeedEventModel.fromDoc(DocumentSnapshot doc) {
    this.uid = doc['uid'];
    this.originUserId = doc['originUserId'];
    this.projectId = doc['projectId'];
    this.projectName = doc['projectName'];
    this.description = doc['description'];
    this.selfDescription = doc['selfDescription'];
    this.details = doc['details'];
    this.timestamp = coerceFirestoreTimestamp(doc['timestamp']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'originUserId': this.originUserId,
      'projectId': this.projectId,
      'projectName': this.projectName,
      'description': this.description,
      'selfDescription': this.selfDescription,
      'details': this.details,
      'timestamp': this.timestamp == null ? '' : Timestamp.fromDate(this.timestamp),
    };
  }

  int get daysSinceEpoch {
    return this.timestamp.difference(DateTime.fromMicrosecondsSinceEpoch(0)).inDays;
  }
}