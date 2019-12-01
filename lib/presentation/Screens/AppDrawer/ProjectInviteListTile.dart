import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Screens/AppDrawer/ProjectInviteListTileButtons.dart';

class ProjectInviteListTile extends StatelessWidget {
  final String projectId;
  final String projectName;
  final String sourceEmail;
  final bool isProcessing;
  final dynamic onAccept;
  final dynamic onDeny;

  ProjectInviteListTile({
    this.projectId,
    this.projectName,
    this.sourceEmail,
    this.isProcessing,
    this.onAccept,
    this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(projectId),
      title: Text(projectName),
      subtitle: Text(sourceEmail), 
      trailing: ProjectInviteListTileButtons(
        isProcessing: isProcessing,
        onAccept: onAccept,
        onDeny: onDeny,
      ),
    );
  }
}