import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/utilities/firestoreReferenceGetters.dart';

void clearTaskReminder(String taskId, String projectId, String userId) async {
  var ref = getTasksCollectionRef(projectId).document(taskId);

  try {
    await ref.updateData({'reminders.$userId': FieldValue.delete()});
  } catch (error) {
    throw error;
  }
}