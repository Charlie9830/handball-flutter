import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/Member.dart';

class User {
  final bool isLoggedIn;
  final String email;
  final String userId;
  final String displayName;

  User({this.isLoggedIn, this.email, this.userId, this.displayName});

  MemberModel toMember(MemberRole role, MemberStatus status) {
    return MemberModel(
      displayName: this.displayName,
      email: this.email,
      userId: this.userId,
      role: role,
      status: status,
    );
  }
}