
import 'package:cloud_firestore/cloud_firestore.dart';

DocumentReference getAccountConfigDocumentReference(String userId) {
  return Firestore.instance
      .collection('users')
      .document(userId)
      .collection('accountConfig')
      .document('0');
}

CollectionReference getInvitesCollectionRef(
  String userId,
) {
  return Firestore.instance
      .collection('users')
      .document(userId)
      .collection('invites');
}

CollectionReference getTaskCommentCollectionRef(
  String projectId,
  String taskId,
) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('tasks')
      .document(taskId)
      .collection('taskComments');
}

CollectionReference getMembersCollectionRef(
  String projectId,
) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('members');
}

CollectionReference getActivityFeedCollectionRef(String projectId) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('activityFeed');
}

CollectionReference getTasksCollectionRef(String projectId) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('tasks');
}

CollectionReference getTaskListsCollectionRef(String projectId) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('taskLists');
}

CollectionReference getProjectMembersCollectionRef(String projectId) {
  return Firestore.instance
      .collection('projects')
      .document(projectId)
      .collection('members');
}

CollectionReference getProjectIdsCollectionRef(String userId) {
  return Firestore.instance
      .collection('users')
      .document(userId)
      .collection('projectIds');
}

CollectionReference getProjectsCollectionRef() {
  return Firestore.instance.collection('projects');
}


CollectionReference getJobsQueueCollectionRef() {
  return Firestore.instance.collection('jobsQueue');
}