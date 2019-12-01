import 'package:handball_flutter/models/Member.dart';

class Assignment {
  String userId;
  String displayName;

  Assignment({
    this.userId,
    this.displayName = '',
  });

  Assignment.fromMap(Map<dynamic, dynamic> map) {
    this.userId = map['userId'];
    this.displayName = map['displayName'];
  }

  Assignment.fromMemberModel(MemberModel member) {
    this.userId = member.userId;
    this.displayName = member.displayName;
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'displayName': this.displayName,
    };
  }
}