import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/ShareProjectViewModel.dart';
import 'package:handball_flutter/presentation/Screens/ShareProject/InviteUserField.dart';
import 'package:handball_flutter/presentation/Screens/ShareProject/MemberList.dart';
import 'package:handball_flutter/presentation/Screens/ShareProject/ProjectActions.dart';

class ComplexShareProject extends StatelessWidget {
  final ShareProjectViewModel viewModel;

  ComplexShareProject({
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InviteUserField(
            isInvitingUser: viewModel.isInvitingUser,
            autofocus: false,
            onInvite: viewModel.onInvite,
          ),
        )),
        Expanded(
          child: Card(
              child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              MemberList(
                title: 'Owners',
                viewModels: viewModel.memberViewModels
                    .where((item) => item.data.role == MemberRole.owner)
                    .toList(),
              ),
              MemberList(
                title: 'Members',
                viewModels: viewModel.memberViewModels
                    .where((item) => item.data.role == MemberRole.member)
                    .toList(),
              ),
            ],
          )),
        ),
        Card(
          child: ProjectActions(
            onDelete: viewModel.onDelete,
            onLeave: viewModel.onLeave,
          ),
        )
      ],
    ));
  }
}
