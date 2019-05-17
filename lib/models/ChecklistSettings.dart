import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistSettingsModel {
  DateTime initialStartDate;
  bool isChecklist;
  DateTime lastRenewDate;
  int renewInterval;

  ChecklistSettingsModel({
    this.initialStartDate,
    this.isChecklist = false,
    this.lastRenewDate,
    this.renewInterval = 1,
  });

  ChecklistSettingsModel.fromDocMap(Map<dynamic, dynamic> docMap) {
    this.initialStartDate = docMap['initialStartDate'] == '' ? null : DateTime.parse(docMap['initialStartDate']);
    this.isChecklist = docMap['isChecklist'] ?? false;
    this.lastRenewDate = docMap['lastRenewDate'] == '' ? null : DateTime.parse(docMap['lastRenewDate']);
    this.renewInterval = docMap['renewInterval'] ?? 1;
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'initialStartDate': this.initialStartDate?.toIso8601String() ?? '',
      'isChecklist': this.isChecklist,
      'lastRenewDate': this.lastRenewDate?.toIso8601String() ?? '',
      'renewInterval': this.renewInterval,
    };
  }
}