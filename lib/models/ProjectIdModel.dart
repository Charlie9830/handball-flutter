import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/utilities/coerceDate.dart';
import 'package:meta/meta.dart';

class ProjectIdModel {
  String uid;
  String archivedProjectName;
  bool isArchived;
  DateTime archivedOn;

  
  ProjectIdModel({
    @required this.uid,
    @required this.archivedProjectName,
    @required this.isArchived,
    @required this.archivedOn,
  });
  
  ProjectIdModel.fromDoc(DocumentSnapshot doc) {
    this.uid = doc['uid'];
    this.archivedProjectName = doc['archivedProjectName'];
    this.isArchived = doc['isArchived'] ?? false;
    this.archivedOn = coerceDate(doc['archivedOn']);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'archivedProjectName': this.archivedProjectName,
      'isArchived': this.isArchived,
      'archivedOn': this.archivedOn?.toIso8601String() ?? '',
    };
  }
}