import 'package:flutter/material.dart';
import 'package:handball_flutter/models/ProjectInvite.dart';
import 'package:handball_flutter/presentation/ReactiveAnimatedList.dart';
import 'package:handball_flutter/presentation/Screens/AppDrawer/ProjectInviteListTile.dart';

class ProjectInviteList extends StatelessWidget {
  final List<ProjectInviteViewModel> viewModels;

  ProjectInviteList({
    this.viewModels,
  });

  @override
  Widget build(BuildContext context) {
    return Container (
      child: ReactiveAnimatedList(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: _getProjectInviteListTiles(),
      )
    );
  }

  List<ProjectInviteListTile> _getProjectInviteListTiles() {
    return viewModels.map( (viewModel) {
      return ProjectInviteListTile(
      projectId: viewModel.data.projectId,
      projectName: viewModel.data.projectName,
      sourceEmail: viewModel.data.sourceEmail,
      isProcessing: viewModel.isProcessing,
      onAccept: viewModel.onAccept,
      onDeny: viewModel.onDeny,
    );
    }).toList();
    
  }  
}