import 'package:cloud_firestore/cloud_firestore.dart';

class GroupedDocumentChanges {
  List<DocumentChange> removed;
  List<DocumentChange> modified;
  List<DocumentChange> added;

  GroupedDocumentChanges() {
    this.removed = <DocumentChange>[];
    this.modified = <DocumentChange>[];
    this.added = <DocumentChange>[];
  }
}