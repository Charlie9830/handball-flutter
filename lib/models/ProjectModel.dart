import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/utilities/coerceFirestoreTimestamp.dart';
import 'package:meta/meta.dart';

class ProjectModel {
  String uid;
  String projectName;
  String created;
  bool isDeleted;
  DateTime deletedOn;

  ProjectModel({
    @required this.uid,
    this.projectName,
    this.created,
    this.isDeleted = false,
    this.deletedOn,
  });

  ProjectModel.fromDoc(DocumentSnapshot doc) {
    this.uid = doc['uid'];
    this.projectName = doc['projectName'];
    this.created = doc['created'];
    this.isDeleted = doc['isDeleted'] ?? false;
    this.deletedOn = coerceFirestoreTimestamp(doc['deletedOn']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'projectName': this.projectName,
      'created': this.created,
      'isDeleted': this.isDeleted,
      'deletedOn': this.deletedOn == null ? null : Timestamp.fromDate(this.deletedOn)
    };
  }

  
}

class ProjectViewModel {
  final ProjectModel data;
  final bool isSelected;
  final bool hasUnreadComments;
  final int laterDueDates;
  final int soonDueDates;
  final int todayDueDates;
  final int overdueDueDates;
  final dynamic onSelect;
  final dynamic onDelete;
  final dynamic onShare;

  ProjectViewModel({
    this.data,
    this.isSelected,
    this.hasUnreadComments,
    this.laterDueDates,
    this.soonDueDates,
    this.todayDueDates,
    this.overdueDueDates,
    this.onSelect,
    this.onDelete,
    this.onShare,
  });
}
