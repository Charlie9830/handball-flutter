import 'package:flutter/material.dart';
import 'package:handball_flutter/models/Member.dart';

class DelegateOwnerDialog extends StatefulWidget {
  final List<MemberModel> members;

  DelegateOwnerDialog({
    Key key,
    this.members,
  }) : super(key: key);

  _DelegateOwnerDialogState createState() => _DelegateOwnerDialogState();
}

class _DelegateOwnerDialogState extends State<DelegateOwnerDialog> {
  String _selectedUserId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choose a project owner'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
                'You are the last owner of this project, Another contributor must be delegated as an owner before you can leave.'),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: _getChildren(),
            )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        FlatButton(
          child: Text('Leave Project'),
          onPressed: _selectedUserId != null
              ? () => Navigator.of(context).pop(_selectedUserId)
              : null,
        )
      ],
    );
  }

  List<Widget> _getChildren() {
    return widget.members.map((member) {
      return ListTile(
        leading: Checkbox(
            value: _selectedUserId == member.userId,
            onChanged: (newValue) =>
                setState(() => _selectedUserId = member.userId)),
        title: Text(member.displayName),
        onTap: () => setState(() => _selectedUserId = member.userId),
      );
    }).toList();
  }
}
