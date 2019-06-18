import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/presentation/Screens/ShareProject/MemberActionsRow.dart';
import 'package:handball_flutter/presentation/Screens/ShareProject/StatusText.dart';

class MemberListTile extends StatefulWidget {
  final Key key;
  final String displayName;
  final String email;
  final MemberStatus status;
  final bool isProcessing;
  final dynamic onPromote;
  final dynamic onKick;
  final dynamic onDemote;

  MemberListTile(
      {this.key,
      this.displayName,
      this.isProcessing,
      this.email,
      this.status,
      this.onPromote,
      this.onKick,
      this.onDemote})
      : super(key: key);

  @override
  _MemberListTileState createState() => _MemberListTileState();
}

class _MemberListTileState extends State<MemberListTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ExpansionTile(
          onExpansionChanged: (value) => setState( () => isExpanded = value),
          leading: isExpanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
          title: Text(widget.displayName ?? ''),
          trailing: StatusText(status: widget.status),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(widget.email ?? ''),
                Text('Joined before time began')
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: MemberActionsRow(
                isProcessing: widget.isProcessing,
                onDemote: widget.onDemote,
                onPromote: widget.onPromote,
                onKick: widget.onKick,
              ),
            )
          ],
        )
      ],
    );
  }
}

