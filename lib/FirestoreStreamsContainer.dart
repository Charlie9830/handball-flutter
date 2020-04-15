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
    requests.addAll(
        this.projectSubscriptions.values.map((item) => item.cancelAll()));

    return Future.wait(requests.where((item) => item != null));
  }
}

// Contains a Project subscription broken into two components. The project property represents the project doc itself, the guts property represents
// subscriptions to all the 'guts' of a project, ie the Tasks, TaskLists, Members etc. This is because during subscription handling we need a way to 
// programatically subscribe and unsubscribe the 'guts' of a project whilst still listening to the project doc itself based on the state of project.isDeleted.
class ProjectSubscriptionContainer {
  final String uid;

  StreamSubscription<DocumentSnapshot> project;
  ProjectGutsSubscriptionContainer guts;

  ProjectSubscriptionContainer({
    @required this.uid,
    this.project,
    this.guts,
  });

  Future<void> cancelAll() {
    List<Future<void>> requests = [];

    requests.add(this.project?.cancel());
    requests.add(this.guts?.cancelAll());

    return Future.wait(requests.where((item) => item != null));
  }
}

class ProjectGutsSubscriptionContainer {
  StreamSubscription<QuerySnapshot> taskLists;
  StreamSubscription<QuerySnapshot> incompletedTasks;
  StreamSubscription<QuerySnapshot> completedTasks;
  StreamSubscription<QuerySnapshot> members;

  ProjectGutsSubscriptionContainer({
    this.taskLists,
    this.incompletedTasks,
    this.completedTasks,
    this.members,
  });

  Future<void> cancelAll() {
    List<Future<void>> requests = [];

    requests.add(this.taskLists?.cancel());
    requests.add(this.incompletedTasks?.cancel());
    requests.add(this.completedTasks?.cancel());
    requests.add(this.members?.cancel());

    return Future.wait(requests.where((item) => item != null));
  }
}
