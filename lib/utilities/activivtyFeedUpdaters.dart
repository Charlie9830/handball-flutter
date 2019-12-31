import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:handball_flutter/models/ActivityFeedEventModel.dart';
import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:handball_flutter/utilities/firestoreReferenceGetters.dart';

import '../enums.dart';

DocumentReference updateActivityFeedWithMemberAction({
  @required String projectId,
  @required String originUserId,
  @required String targetDisplayName,
  @required projectName,
  @required ActivityFeedEventType type,
  @required title,
  @required details,
}) {
  var ref = getActivityFeedCollectionRef(projectId).document();
  var event = ActivityFeedEventModel(
    uid: ref.documentID,
    originUserId: originUserId,
    type: type,
    projectId: projectName,
    projectName: projectName,
    title: '$targetDisplayName $title',
    selfTitle: 'You left the project.',
    details: details ?? '',
    timestamp: DateTime.now(),
  );

  ref.setData(event.toMap());
  return ref;
}

DocumentReference updateActivityFeed(
    {@required String projectId,
    @required UserModel user,
    @required projectName,
    @required ActivityFeedEventType type,
    @required String title,
    @required String details,
    List<Assignment> assignments}) {
  var ref = getActivityFeedCollectionRef(projectId).document();
  var event = ActivityFeedEventModel(
    uid: ref.documentID,
    originUserId: user.userId,
    type: type,
    projectId: projectId,
    projectName: projectName,
    title: '${user.displayName} $title ',
    selfTitle: 'You $title',
    details: details ?? '',
    timestamp: DateTime.now(),
    assignments: assignments,
  );

  ref.setData(event.toMap());

  return ref;
}

DocumentReference updateActivityFeedToBatch(
    {@required String projectId,
    @required UserModel user,
    @required projectName,
    @required ActivityFeedEventType type,
    @required String title,
    @required String details,
    @required WriteBatch batch,
    bool isSelfAssignment = false, // Speical case for selfAssignment. Adjusts the wording slightly.
    List<Assignment> assignments}) {
  var ref = getActivityFeedCollectionRef(projectId).document();
  var event = ActivityFeedEventModel(
    uid: ref.documentID,
    originUserId: user.userId,
    type: type,
    projectId: projectId,
    projectName: projectName,
    title: isSelfAssignment ? '${user.displayName} $title themselves. ' : '${user.displayName} $title ',
    selfTitle: isSelfAssignment ? 'You $title yourself.' : 'You $title',
    details: details,
    timestamp: DateTime.now(),
    assignments: assignments,
  );

  batch.setData(ref, event.toMap());
  return ref;
}