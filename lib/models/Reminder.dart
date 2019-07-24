import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/utilities/coerceDate.dart';
import 'package:meta/meta.dart';

class ReminderModel {
  String userId;
  String originTaskId;
  DateTime time;
  String title;
  String message;
  bool isSeen;

  /* 
  Update copyWith Method Below.
  */

  ReminderModel({
    @required this.userId,
    @required this.originTaskId,
    @required this.time,
    @required this.title,
    @required this.message,
    @required this.isSeen,
  });

  ReminderModel.removed(String taskId) {
    this.originTaskId = taskId;
  }

  ReminderModel.fromMap(Map<dynamic, dynamic> map) {
    this.userId = map['userId'];
    this.title = map['title'];
    this.message = map['message'];
    this.originTaskId = map['originTaskId'];
    this.time = coerceDate(map['time']);
    this.isSeen = map['isSeen'];
  }

  ReminderModel.fromJSON(String json) {
    var decoder = JsonDecoder();
    var map = decoder.convert(json);

    this.userId = map['userId'];
    this.title = map['title'];
    this.message = map['message'];
    this.originTaskId = map['originTaskId'];
    this.time = coerceDate(map['time']);
    this.isSeen = map['isSeen'];
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'userId': this.userId,
      'originTaskId': this.originTaskId,
      'title': this.title,
      'message': this.message,
      'time': this.time?.toIso8601String() ?? '',
      'isSeen': this.isSeen,
    };
  }

  String toJSON() {
    var encoder = JsonEncoder();
    return encoder.convert(this.toMap());
  }

  ReminderModel copyWith({
    String userId,
    String originTaskId,
    String title,
    String message,
    DateTime time,
    bool isSeen,
  }) {
    return ReminderModel(
      userId: userId ?? this.userId,
      originTaskId: originTaskId ?? this.originTaskId,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      isSeen: isSeen ?? this.isSeen,
    );
  }

  int get notificationId {
    return this.originTaskId.hashCode;
  }
}
