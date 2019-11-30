// ignore_for_file: cancel_subscriptions
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreStreamsContainer {
  // User Level.
  StreamSubscription<QuerySnapshot> projectIds;
  StreamSubscription<QuerySnapshot> invites;
  StreamSubscription<DocumentSnapshot> accountConfig;

  Map<String, ProjectSubscriptionContainer> projectSubscriptions;

  FirestoreStreamsContainer() {
    this.projectSubscriptions = <String, ProjectSubscriptionContainer>{};
  }

  Future<void> cancelAll() {
    List<Future<void>> requests = [];

    requests.add(this.projectIds?.cancel());
    requests.add(this.invites?.cancel());
    requests.add(this.accountConfig?.cancel());
    requests.addAll(this.projectSubscriptions.values.map((item) => item.cancelAll()));

    Future.wait(requests.where((item) => item != null));
  }
}

class ProjectSubscriptionContainer {
  final String uid;

  StreamSubscription<DocumentSnapshot> project;
  StreamSubscription<QuerySnapshot> taskLists;
  StreamSubscription<QuerySnapshot> incompletedTasks;
  StreamSubscription<QuerySnapshot> completedTasks;
  StreamSubscription<QuerySnapshot> members;

  ProjectSubscriptionContainer({
    @required this.uid,
    this.project,
    this.taskLists,
    this.incompletedTasks,
    this.completedTasks,
    this.members,
  });

  Future<void> cancelAll() {
    List<Future<void>> requests = [];

    requests.add(this.project?.cancel());
    requests.add(this.taskLists?.cancel());
    requests.add(this.incompletedTasks?.cancel());
    requests.add(this.completedTasks?.cancel());
    requests.add(this.members?.cancel());

    return Future.wait(requests.where((item) => item != null));
  }
}