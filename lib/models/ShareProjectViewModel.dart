import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/ProjectModel.dart';

class ShareProjectViewModel {
  final ProjectModel projectEntity;
  final ShareProjectScreenType type;
  final List<MemberViewModel> memberViewModels;
  final bool isInvitingUser;
  final dynamic onInvite;
  final dynamic onDelete;
  final dynamic onLeave;

  ShareProjectViewModel({
    this.projectEntity,
    this.memberViewModels,
    this.isInvitingUser,
    this.type,
    this.onInvite,
    this.onDelete,
    this.onLeave
  });
}