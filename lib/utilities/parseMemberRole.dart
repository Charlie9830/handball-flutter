import 'package:handball_flutter/enums.dart';

MemberRole parseMemberRole(String role) {
  if (role == 'member') {
    return MemberRole.member;
  }

  if (role == 'owner') {
    return MemberRole.owner;
  }

  throw UnsupportedError("Could not parse role into MemberRole. Role: $role");
}
