import 'package:handball_flutter/utilities/coerceDate.dart';
import 'package:meta/meta.dart';

class ReminderModel {
  String originTaskId;
  DateTime time;
  bool isSeen;

  /* 
  Update copyWith Method Below.
  */

  ReminderModel({
    @required this.originTaskId,
    @required this.time,
    @required this.isSeen,
  });

  ReminderModel.fromMap(Map<dynamic, dynamic> map) {
    this.originTaskId = map['originTaskId'];
    this.time = coerceDate(map['time']);
    this.isSeen = map['isSeen'];
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'time': this.time?.toIso8601String() ?? '',
      'isSeen': this.isSeen,
    };
  }

  ReminderModel copyWith({
    String originTaskId,
    DateTime time,
    bool isSeen,
  }) {
    return ReminderModel(
      originTaskId: originTaskId ?? this.originTaskId,
      time: time ?? this.time,
      isSeen: isSeen ?? this.isSeen,
    );
  }
}