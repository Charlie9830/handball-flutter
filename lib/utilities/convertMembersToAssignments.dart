import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/models/Member.dart';

List<Assignment> convertMembersToAssignments(List<MemberModel> projectMembers) {
  if (projectMembers == null) {
    <Assignment>[];
  }

  return projectMembers.map( (item) => Assignment(userId: item.userId, displayName: item.displayName)).toList();
}