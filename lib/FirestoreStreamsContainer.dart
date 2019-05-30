// ignore_for_file: cancel_subscriptions

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreStreamsContainer {
  // Local
  StreamSubscription<QuerySnapshot> localProjects;
  StreamSubscription<QuerySnapshot> localTaskLists;
  StreamSubscription<QuerySnapshot> localIncompletedTasks;
  StreamSubscription<QuerySnapshot> localCompletedTasks;
  StreamSubscription<QuerySnapshot> remoteProjectIds;
  StreamSubscription<QuerySnapshot> invites;
  StreamSubscription<QuerySnapshot> accountConfig;

  // Remotes
  Map<String, RemoteProjectSubscription> remotes;

  void cancelAll() {
    localProjects?.cancel();
    localTaskLists?.cancel();
    localIncompletedTasks?.cancel();
    localCompletedTasks?.cancel();
    remoteProjectIds?.cancel();
    invites?.cancel();
    accountConfig?.cancel();

    remotes?.forEach((key, value) => value?.cancelAll);
  }
}

class RemoteProjectSubscription {
  StreamSubscription<QuerySnapshot> base;
  StreamSubscription<QuerySnapshot> taskLists;
  StreamSubscription<QuerySnapshot> incompletedTasks;
  StreamSubscription<QuerySnapshot> localCompletedTasks;
  StreamSubscription<QuerySnapshot> members;

  void cancelAll() {
    base?.cancel();
    taskLists?.cancel();
    incompletedTasks?.cancel();
    localCompletedTasks?.cancel();
    members?.cancel();
  }
}