import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/utilities/coerceDate.dart';
import 'package:handball_flutter/utilities/coerceFirestoreTimestamp.dart';
import 'package:handball_flutter/utilities/coerceStringList.dart';
import 'package:meta/meta.dart';

class CommentModel {
  String uid;
  String text;
  DateTime created;
  String createdBy;
  String displayName;
  List<String> seenBy;
  DateTime timestamp;
  bool isSynced;
  DocumentSnapshot docSnapshot; // Helps keep track of Pagination.

  CommentModel({
    @required this.uid,
    @required this.text,
    @required this.created,
    @required this.createdBy,
    @required this.displayName,
    @required this.seenBy,
    @required this.timestamp,
    this.isSynced = false,
    this.docSnapshot,
  });

  CommentModel.fromDoc(DocumentSnapshot snapshot) {
    this.uid = snapshot.documentID;
    this.created = coerceDate(snapshot.data['created']);
    this.text = snapshot.data['text'];
    this.createdBy = snapshot.data['createdBy'];
    this.displayName = snapshot.data['displayName'];
    this.seenBy = coerceStringList(snapshot.data['seenBy']);
    this.timestamp = coerceFirestoreTimestamp(snapshot.data['timestamp']);
    this.isSynced = snapshot.metadata.hasPendingWrites == false;
    this.docSnapshot = snapshot;
  }

  CommentModel.fromMap(Map<dynamic, dynamic> map, bool isFromCache) {
    this.uid = map['uid'];
    this.created = coerceDate(map['created']);
    this.text = map['text'];
    this.createdBy = map['createdBy'];
    this.displayName = map['displayName'];
    this.seenBy = coerceStringList(map['seenBy']);
    this.timestamp = coerceFirestoreTimestamp(map['timestamp']);
    this.isSynced = !isFromCache;
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'text': this.text,
      'created': this.created == null ? '' : this.created.toIso8601String(),
      'createdBy': this.createdBy,
      'displayName': this.displayName,
      'seenBy': this.seenBy,
      'timestamp': Timestamp.fromDate(this.created),
    };
  }

  CommentModel copy() {
    return CommentModel(
      uid: this.uid,
      text: this.text,
      docSnapshot: this.docSnapshot,
      isSynced: this.isSynced,
      seenBy: this.seenBy.toList(),
      created: this.created,
      createdBy: this.createdBy,
      displayName: this.displayName,
      timestamp: this.timestamp,
    );
  }

}

class CommentViewModel {
  final CommentModel data;
  final bool isUnread;
  final onDelete;

  CommentViewModel({
    this.data,
    this.isUnread,
    this.onDelete,
  });
}