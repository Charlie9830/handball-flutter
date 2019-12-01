import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:handball_flutter/FirestoreStreamsContainer.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/globals.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/redux/syncActions.dart';
import 'package:handball_flutter/utilities/firestoreReferenceGetters.dart';
import 'package:handball_flutter/utilities/snapshotHandlers.dart';
import 'package:redux/redux.dart';

void subscribeToDatabase(Store<AppState> store, String userId) {
  firestoreStreams.accountConfig = subscribeToAccountConfig(userId, store);
  firestoreStreams.invites = subscribeToProjectInvites(userId, store);
  firestoreStreams.projectIds = subscribeToProjectIds(userId, store);
}

StreamSubscription<DocumentSnapshot> subscribeToAccountConfig(
    String userId, Store<AppState> store) {
  return getAccountConfigDocumentReference(userId)
      .snapshots()
      .listen((docSnapshot) => handleAccountConfigSnapshot(docSnapshot, store));
}

StreamSubscription<QuerySnapshot> subscribeToProjectInvites(
    String userId, Store<AppState> store) {
  return Firestore.instance
      .collection('users')
      .document(userId)
      .collection('invites')
      .snapshots()
      .listen((snapshot) => handleProjectInvitesSnapshot(snapshot, store));
}

StreamSubscription<QuerySnapshot> subscribeToCompletedTasks(
    String projectId,
    Store<AppState> store,
    FlutterLocalNotificationsPlugin notificationsPlugin) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('tasks')
      .where('isComplete', isEqualTo: true)
      .snapshots()
      .listen((snapshot) => handleTasksSnapshot(
          TasksSnapshotType.completed, snapshot, projectId, store));
}

StreamSubscription<QuerySnapshot> subscribeToIncompletedTasks(
  String projectId,
  FlutterLocalNotificationsPlugin notificationsPlugin,
  Store<AppState> store,
) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('tasks')
      .where('isComplete', isEqualTo: false)
      .snapshots()
      .listen((snapshot) => handleTasksSnapshot(
          TasksSnapshotType.incompleted, snapshot, projectId, store));
}

StreamSubscription<QuerySnapshot> subscribeToTaskLists(
    String projectId, Store<AppState> store) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('taskLists')
      .snapshots()
      .listen(
          (snapshot) => handleTaskListsSnapshot(snapshot, projectId, store));
}

StreamSubscription<QuerySnapshot> subscribeToProjectIds(
    String userId, Store<AppState> store) {
  return getProjectIdsCollectionRef(userId)
      .snapshots()
      .listen((snapshot) => handleProjectIdsSnapshot(snapshot, store));
}

StreamSubscription<QuerySnapshot> subscribeToMembers(
    String projectId, Store<AppState> store) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('members')
      .snapshots()
      .listen((snapshot) => handleMembersSnapshot(snapshot, projectId, store));
}

StreamSubscription<DocumentSnapshot> subscribeToProject(
    String projectId, Store<AppState> store) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .snapshots()
      .listen((doc) => handleProjectSnapshot(doc, store));
}

void addProjectSubscription(String projectId, Store<AppState> store) {
  if (firestoreStreams.projectSubscriptions.containsKey(projectId) ||
      firestoreStreams.projectSubscriptions[projectId] != null) {
    return;
  }

  firestoreStreams.projectSubscriptions[projectId] =
      ProjectSubscriptionContainer(
    uid: projectId,
    project: subscribeToProject(projectId, store),
    members: subscribeToMembers(projectId, store),
    taskLists: subscribeToTaskLists(projectId, store),
    incompletedTasks:
        subscribeToIncompletedTasks(projectId, notificationsPlugin, store),
  );
}

void removeProjectSubscription(String projectId, Store<AppState> store) async {
  if (firestoreStreams.projectSubscriptions.containsKey(projectId)) {
    await firestoreStreams.projectSubscriptions[projectId]?.cancelAll();

    firestoreStreams.projectSubscriptions.remove(projectId);

    store.dispatch(RemoveProjectEntities(projectId: projectId));
  }
}
