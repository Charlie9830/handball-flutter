import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/utilities/parseMemberRole.dart';

class ProjectInviteModel {
  String projectName;
  String targetUserId;
  String sourceUserId;
  String sourceEmail;
  String sourceDisplayName;
  String projectId;
  MemberRole role;

  ProjectInviteModel({
    this.projectName,
    this.targetUserId,
    this.sourceUserId,
    this.sourceEmail,
    this.sourceDisplayName,
    this.projectId,
    this.role,
  });


  ProjectInviteModel.fromDoc(DocumentSnapshot doc) {
    this.projectName = doc['projectName'];
    this.targetUserId = doc['targetUserId'];
    this.sourceUserId = doc['sourceUserId'];
    this.sourceEmail = doc['sourceEmail'];
    this.sourceDisplayName = doc['sourceDisplayName'];
    this.projectId = doc['projectId'];
    this.role = parseMemberRole(doc['role']);
  }
}

class ProjectInviteViewModel {
  final ProjectInviteModel data;
  final bool isProcessing;
  final dynamic onAccept;
  final dynamic onDeny;

  ProjectInviteViewModel({
    this.data,
    this.isProcessing,
    this.onAccept,
    this.onDeny,
  });
}