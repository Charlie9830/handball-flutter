import 'package:flutter/material.dart';

class MemberActionsRow extends StatelessWidget {
  final dynamic onPromote;
  final dynamic onDemote;
  final dynamic onKick;

  MemberActionsRow({
    this.onPromote,
    this.onDemote,
    this.onKick
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      OutlineButton(
        child: Text('Promote'),
        onPressed: onPromote,
      ),
      OutlineButton(
        child: Text('Demote'),
        onPressed: onDemote,
      ),
      OutlineButton(
        child: Text('Kick'),
        onPressed: onKick,
      )
    ],);
  }
}
