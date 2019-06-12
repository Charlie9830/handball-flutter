import 'package:flutter/material.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/models/ProjectInvite.dart';
import 'package:handball_flutter/presentation/Screens/AppDrawer/ProjectInviteListTile.dart';

class ProjectInviteList extends StatelessWidget {
  final List<ProjectInviteViewModel> viewModels;

  ProjectInviteList({
    this.viewModels,
  });

  @override
  Widget build(BuildContext context) {
    return Container (
      child: AnimatedList(
        key: projectInviteAnimatedListStateKey,
        shrinkWrap: true,
        initialItemCount: viewModels.length,
        itemBuilder: (context, index, animation) {
          return SizeTransition(
            sizeFactor: animation.drive(Tween(begin: 0, end: 1)),
            axis: Axis.vertical,
            child: _getProjectInviteListTile(index)
          );
        }
      )
    );
  }

  ProjectInviteListTile _getProjectInviteListTile(int index) {
    var viewModel = viewModels[index];
    return ProjectInviteListTile(
      projectId: viewModel.data.projectId,
      projectName: viewModel.data.projectName,
      sourceEmail: viewModel.data.sourceEmail,
      isProcessing: viewModel.isProcessing,
      onAccept: viewModel.onAccept,
      onDeny: viewModel.onDeny,
    );
  }  
}