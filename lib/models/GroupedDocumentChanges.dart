import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class GroupedTaskDocumentChanges {
  List<CustomDocumentChange> removed;
  List<CustomDocumentChange> modified;
  List<CustomDocumentChange> added;

  GroupedTaskDocumentChanges() {
    this.removed = <CustomDocumentChange>[];
    this.modified = <CustomDocumentChange>[];
    this.added = <CustomDocumentChange>[];
  }
}

// Allows us to process Firestore Doc Changes, but output in a format that we can modify.
// Driving the animations for Task Moves requires that we adjust the taskList property.
class CustomDocumentChange {
  String uid;
  String taskList;
  DocumentSnapshot document;

  CustomDocumentChange({
    @required this.uid,
    @required this.taskList,
    @required this.document,
  });
}