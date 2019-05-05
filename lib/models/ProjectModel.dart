import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class ProjectModel {
    String uid;
    String projectName;
    bool isRemote;
    String created;
  
  ProjectModel({
    @required this.uid,
    this.projectName,
    this.isRemote,
    this.created
    });

  ProjectModel.fromDoc(DocumentSnapshot doc) {
    this.uid = doc['uid'];
    this.projectName = doc['projectName'];
    this.isRemote = doc['isRemote'];
    this.created = doc['created'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'projectName': this.projectName,
      'isRemote': this.isRemote,
      'created': this.created,
    };
  }
}


class ProjectViewModel {
  final String projectName;
  final dynamic onSelect;
  final dynamic onDelete;

  ProjectViewModel({
    this.projectName,
    this.onSelect,
    this.onDelete,
    });
}