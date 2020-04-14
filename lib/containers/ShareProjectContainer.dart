import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/ShareProjectViewModel.dart';
import 'package:handball_flutter/presentation/Screens/ShareProject/ShareProjectBase.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/redux/asyncActions.dart';
import 'package:redux/redux.dart';

class ShareProjectContainer extends StatelessWidget {
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, ShareProjectViewModel>(
      converter: (Store<AppState> store) => _converter(store, context),
      builder: (context, viewModel) {
        return new ShareProjectBase(viewModel: viewModel);
      },
    );
  }

  _converter(Store<AppState> store, BuildContext context) {
    var projectId = store.state.projectShareMenuEntity.uid;
    var members = store.state.members[projectId] ?? <MemberModel>[];
    var projectName = store.state.projectShareMenuEntity.projectName;

    return ShareProjectViewModel(
      projectEntity: store.state.projectShareMenuEntity,
      memberViewModels: _buildMemberViewModels(members, store, context),
      type: members.length > 1 && _getOtherMembers(members, store.state.user.userId).isNotEmpty
          ? ShareProjectScreenType.complete
          : ShareProjectScreenType.simplified,
      isInvitingUser: store.state.isInvitingUser,
      onInvite: (email) => store.dispatch(inviteUserToProject(
          email, projectId, projectName, MemberRole.member)),
      onDelete: _canDelete(members, store.state.user.userId)
          ? () => store.dispatch(
              deleteProjectWithDialog(projectId, projectName, context))
          : null,
      onLeave: _canLeave(members, store.state.user.userId)
          ? () => store.dispatch(
              leaveSharedProject(projectId, projectName, members, context))
          : null,
    );
  }

  List<MemberViewModel> _buildMemberViewModels(
      List<MemberModel> members, Store<AppState> store, BuildContext context) {
    var userId = store.state.user.userId;
    var projectId = store.state.projectShareMenuEntity.uid;
    var projectName = store.state.projectShareMenuEntity.projectName;

    return members.map((item) {
      return MemberViewModel(
        data: item,
        onKick: _canBeKicked(item, members, userId)
            ? () => store.dispatch(kickUserFromProject(
                item.userId, projectId, item.displayName, projectName, context))
            : null,
        onDemote: _canBeDemoted(item, members, userId)
            ? () => store.dispatch(demoteUser(item.userId, projectId))
            : null,
        onPromote: _canBePromoted(item, members, userId)
            ? () => store.dispatch(promoteUser(item.userId, projectId))
            : null,
        isProcessing: store.state.processingMembers.contains(item.userId),
      );
    }).toList();
  }

  bool _canLeave(List<MemberModel> members, String selfUserId) {
    if (members.length == 1) {
      return false;
    }

    return _getOtherMembers(members, selfUserId).isNotEmpty;
  }

  List<MemberModel> _getOtherMembers(
      List<MemberModel> members, String selfUserId) {
    return members
        .where((item) => item.userId != selfUserId)
        .toList();
  }

  bool _canDelete(List<MemberModel> members, String selfUserId) {
    var currentMember = _extractCurrentMember(members, selfUserId);

    return currentMember.role == MemberRole.owner;
  }

  bool _canBeKicked(
      MemberModel member, List<MemberModel> members, String userId) {
    var currentMember = _extractCurrentMember(members, userId);

    return currentMember.role == MemberRole.owner &&
        member.userId != currentMember.userId;
  }

  bool _canBePromoted(
      MemberModel member, List<MemberModel> members, String userId) {
    var currentMember = _extractCurrentMember(members, userId);

    return currentMember.role == MemberRole.owner &&
        member.role == MemberRole.member &&
        member.status != MemberStatus.denied;
  }

  bool _canBeDemoted(
      MemberModel member, List<MemberModel> members, String userId) {
    var currentMember = _extractCurrentMember(members, userId);

    return currentMember.role == MemberRole.owner &&
        member.role == MemberRole.owner &&
        member.status != MemberStatus.denied;
  }

  MemberModel _extractCurrentMember(List<MemberModel> members, String userId) {
    return members.firstWhere((item) => item.userId == userId,
        orElse: () => null);
  }
}
