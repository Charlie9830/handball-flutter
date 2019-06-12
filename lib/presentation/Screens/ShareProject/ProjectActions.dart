import 'package:flutter/material.dart';

class ProjectActions extends StatelessWidget {
  final dynamic onLeave;
  final dynamic onDelete;

  ProjectActions({
    this.onDelete,
    this.onLeave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        FlatButton(
          child: Text('Leave Project'),
          textColor: Theme.of(context).buttonTheme.colorScheme.secondaryVariant,
          onPressed: onLeave,
        ),
        FlatButton(
          child: Text('Delete Project'),
          textColor: Theme.of(context).buttonTheme.colorScheme.secondaryVariant,
          onPressed: onDelete,
        ),
      ],
    );
  }
}