import 'package:cloud_firestore/cloud_firestore.dart';

class Assignment {
  String userId;
  String displayName;

  Assignment({
    this.userId,
    this.displayName = '',
  });

  Assignment.fromMap(Map<String, dynamic> map) {
    this.userId = map['userId'];
    this.displayName = map['displayName'];
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'displayName': this.displayName,
    };
  }
}