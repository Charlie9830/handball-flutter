import 'package:flutter/material.dart';
import 'package:handball_flutter/models/ShareProjectViewModel.dart';
import 'package:handball_flutter/presentation/Screens/ShareProject/InviteUserField.dart';

class SimplifiedShareProject extends StatelessWidget {
  final ShareProjectViewModel viewModel;

  SimplifiedShareProject({
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          InviteUserField(
            isInvitingUser: viewModel.isInvitingUser,
            autofocus: true,
            onInvite: viewModel.onInvite,
          )
        ],
      )
    );
  }
}