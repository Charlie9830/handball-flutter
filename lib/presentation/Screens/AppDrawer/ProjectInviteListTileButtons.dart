import 'package:flutter/material.dart';

class ProjectInviteListTileButtons extends StatelessWidget {
  final bool isProcessing;
  final dynamic onAccept;
  final dynamic onDeny;

  ProjectInviteListTileButtons({
    this.isProcessing,
    this.onAccept,
    this.onDeny,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (isProcessing == false)
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: onDeny,
          ),
        if (isProcessing == false)
        IconButton(
          icon: Icon(Icons.check),
          onPressed: onAccept,
        ),
        if (isProcessing == true)
          CircularProgressIndicator()
      ],
    );
  }
}
