import 'package:cloud_firestore/cloud_firestore.dart';

DateTime coerceFirestoreTimestamp(Timestamp timestamp) {
  if (timestamp == null) {
    return null;
  }

  return timestamp.toDate();
}