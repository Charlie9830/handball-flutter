import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/utilities/coerceStringList.dart';
import 'package:handball_flutter/utilities/parseMemberRole.dart';

class MemberModel {
  String userId;
  String displayName;
  String email;
  MemberStatus status;
  MemberRole role;
  List<String> listCustomSortOrder;
  String favouriteTaskListId;

  MemberModel({
    this.userId,
    this.displayName,
    this.email,
    this.status = MemberStatus.pending,
    this.role = MemberRole.member,
    this.listCustomSortOrder,
    this.favouriteTaskListId = '-1',
  });

  MemberModel.fromDoc(DocumentSnapshot doc) {
    this.userId = doc.data['userId'];
    this.displayName = doc.data['displayName'] ?? '';
    this.email = doc.data['email'] ?? '';
    this.status = _parseStatus(doc.data['status']);
    this.role = parseMemberRole(doc.data['role']);
    this.listCustomSortOrder = coerceStringList(doc.data['listCustomSortOrder']) ?? <String>[];
    this.favouriteTaskListId = _coerceFavouriteTaskListId(doc.data['favouriteTaskListId']);
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'displayName': this.displayName,
      'email': this.email,
      'status': _convertStatusToString(this.status),
      'role': _convertRoleToString(this.role),
      'listCustomSortOrder': this.listCustomSortOrder ?? <String>[],
      'favouriteTaskListId': this.favouriteTaskListId ?? '-1',
    };
  }
  
  String _coerceFavouriteTaskListId(String taskListId) {
    if (taskListId == null) {
      return '-1';
    }

    return taskListId;
  }

  String _convertStatusToString(MemberStatus status) {
    switch(status) {
      case MemberStatus.pending:
        return 'pending';

      case MemberStatus.added:
        return 'added';

      case MemberStatus.denied:
        return 'rejected invite';
      
      default:
        throw UnsupportedError('Cannot convert Member.status to String. Value: $status');
    }
  }

  String _convertRoleToString(MemberRole role) {
    switch(role) {
      
      case MemberRole.member:
        return 'member';

      case MemberRole.owner:
        return 'owner';

      default:
        throw UnsupportedError('Cannot convert Member.role to String. Value: $role');
    }
  }

  MemberStatus _parseStatus(String status) {
    switch(status) {
      case 'pending':
        return MemberStatus.pending;

      case 'added':
        return MemberStatus.added;

      case 'rejected invite':
        return MemberStatus.denied;

      default:
        throw UnsupportedError('Unknown value when parsing Member.status. Value: $status');
    }
  }
}

class MemberViewModel {
  final MemberModel data;
  final bool isProcessing;
  final dynamic onKick;
  final dynamic onPromote;
  final dynamic onDemote;

  MemberViewModel({
    this.data,
    this.isProcessing,
    this.onKick,
    this.onPromote,
    this.onDemote,
  });
}