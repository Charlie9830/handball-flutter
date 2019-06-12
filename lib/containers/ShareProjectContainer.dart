import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/AppDrawerScreenViewModel.dart';
import 'package:handball_flutter/models/AppSettingsViewModel.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/ShareProjectViewModel.dart';
import 'package:handball_flutter/models/TaskInspectorScreenViewModel.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AppSettings.dart';
import 'package:handball_flutter/presentation/Screens/ShareProject/ShareProjectBase.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/TaskInspectorScreen.dart';
import 'package:handball_flutter/redux/actions.dart';
import 'package:handball_flutter/redux/appState.dart';
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
    var members = store.state.members[store.state.projectShareMenuEntity.uid] ??
        <MemberModel>[];

    return ShareProjectViewModel(
      projectEntity: store.state.projectShareMenuEntity,
      memberViewModels: _buildMemberViewModels(members, store),
      type: members.length > 1
          ? ShareProjectScreenType.complete
          : ShareProjectScreenType.simplified,
      isInvitingUser: store.state.isInvitingUser,
      onInvite: (email) => store.dispatch(inviteUserToProject(
          email,
          store.state.projectShareMenuEntity.uid,
          store.state.projectShareMenuEntity.projectName,
          MemberRole.member)),
      onDelete: _canDelete(members, store.state.user.userId)
          ? () => store.dispatch(deleteProjectWithDialog(
              store.state.projectShareMenuEntity.uid,
              store.state.projectShareMenuEntity.projectName,
              context))
          : null,
      onLeave: () => {},
    );
  }

  List<MemberViewModel> _buildMemberViewModels(
      List<MemberModel> members, Store<AppState> store) {
    var userId = store.state.user.userId;

    return members.map((item) {
      return MemberViewModel(
        data: item,
        onKick: _canBeKicked(item, members, userId) ? () {} : null,
        onDemote: _canBeDemoted(item, members, userId) ? () {} : null,
        onPromote: _canBePromoted(item, members, userId) ? () {} : null,
      );
    }).toList();
  }

  bool _canDelete(List<MemberModel> members, String userId) {
    var currentMember = _extractCurrentMember(members, userId);

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
        member.role == MemberRole.member;
  }

  bool _canBeDemoted(
      MemberModel member, List<MemberModel> members, String userId) {
    var currentMember = _extractCurrentMember(members, userId);

    return currentMember.role == MemberRole.owner &&
        member.role == MemberRole.owner;
  }

  MemberModel _extractCurrentMember(List<MemberModel> members, String userId) {
    return members.firstWhere((item) => item.userId == userId,
        orElse: () => null);
  }
}
