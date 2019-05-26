import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/utilities/normalizeDate.dart';

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

  ChecklistSettingsModel copyWith({
    initialStartDate,
    isChecklist,
    lastRenewDate,
    renewInterval,
  }) {
    return ChecklistSettingsModel(
      initialStartDate: initialStartDate ?? this.initialStartDate,
      isChecklist: isChecklist ?? this.isChecklist,
      lastRenewDate: lastRenewDate ?? this.lastRenewDate,
      renewInterval: renewInterval ?? this.renewInterval,
    );
  }

  bool get isDueForRenew {
    if (nextRenewDate == null) {
      return false;
    }

    return nextRenewDate.isBefore(normalizeDate(DateTime.now()));
  }

  DateTime get nextRenewDate {
    if (initialStartDate == null && lastRenewDate == null) {
      return null;
    }

    if (lastRenewDate == null && initialStartDate != null) {
      // First auto renew hasn't occured yet. Extrapolate from initialStartDate.
      return initialStartDate.add(Duration(days: renewInterval));
    }

    if (lastRenewDate != null) {
      // Auto renew has occured previously, Extrapolate from lastRenewDate.
      return lastRenewDate.add(Duration(days: renewInterval));
    }

    return null;
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'initialStartDate': normalizeDate(this.initialStartDate)?.toIso8601String() ?? '',
      'isChecklist': this.isChecklist,
      'lastRenewDate': normalizeDate(this.lastRenewDate)?.toIso8601String() ?? '',
      'renewInterval': this.renewInterval,
    };
  }
}