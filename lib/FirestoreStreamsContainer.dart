// ignore_for_file: cancel_subscriptions
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FirestoreStreamsContainer {
  // User Level.
  StreamSubscription<QuerySnapshot> projectIds;
  StreamSubscription<QuerySnapshot> invites;
  StreamSubscription<QuerySnapshot> accountConfig;

  Map<String, ProjectSubscriptionContainer> projectSubscriptions;

  FirestoreStreamsContainer() {
    this.projectSubscriptions = <String, ProjectSubscriptionContainer>{};
  }

  void cancelAll() {
    this.projectIds?.cancel();
    this.invites?.cancel();
    this.accountConfig?.cancel();

    this.projectSubscriptions.forEach( (key, projectSub) => projectSub?.cancelAll());
  }
}

class ProjectSubscriptionContainer {
  final String uid;

  StreamSubscription<DocumentSnapshot> project;
  StreamSubscription<QuerySnapshot> taskLists;
  StreamSubscription<QuerySnapshot> incompletedTasks;
  StreamSubscription<QuerySnapshot> completedTasks;

  ProjectSubscriptionContainer({
    @required this.uid,
    this.project,
    this.taskLists,
    this.incompletedTasks,
    this.completedTasks,
  });

  void cancelAll() {
    this.project?.cancel();
    this.taskLists?.cancel();
    this.incompletedTasks?.cancel();
    this.completedTasks?.cancel();
  }

}