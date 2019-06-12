import 'package:handball_flutter/enums.dart';

String convertMemberRole(MemberRole role) {
  switch(role) {
    case MemberRole.member:
      return 'member';

    case MemberRole.owner:
      return 'owner';

    default:
    throw UnsupportedError('Could not convert provided MemberRole to String. role: $role');
  }
}