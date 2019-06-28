import 'package:handball_flutter/models/Member.dart';

List<String> extractListCustomSortOrder(
    Map<String, List<MemberModel>> members, String projectId, String userId) {
  if (projectId == '-1') {
    return null;
  }

  return members[projectId]
      ?.firstWhere((item) => item.userId == userId, orElse: () => null)
      ?.listCustomSortOrder;
}