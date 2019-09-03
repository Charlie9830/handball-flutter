import 'package:handball_flutter/models/Member.dart';

String extractFavouriteTaskListId(
    Map<String, MemberModel> memberLookup, String projectId, String userId) {
  if (projectId == '-1') {
    return '-1';
  }

  if (memberLookup.containsKey(userId)) {
    return memberLookup[userId].favouriteTaskListId;
  }

  return '-1';
}