import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/enums.dart';
import 'package:meta/meta.dart';

class ProjectModel {
  String uid;
  String projectName;
  String created;

  ProjectModel({
    @required this.uid,
    this.projectName,
    this.created,
  });

  ProjectModel.fromDoc(DocumentSnapshot doc) {
    this.uid = doc['uid'];
    this.projectName = doc['projectName'];
    this.created = doc['created'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'projectName': this.projectName,
      'created': this.created,
    };
  }

  
}

class ProjectViewModel {
  final bool isSelected;
  final String projectName;
  final bool hasUnreadComments;
  final int laterDueDates;
  final int soonDueDates;
  final int todayDueDates;
  final int overdueDueDates;
  final dynamic onSelect;
  final dynamic onDelete;
  final dynamic onShare;

  ProjectViewModel({
    this.isSelected,
    this.projectName,
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
