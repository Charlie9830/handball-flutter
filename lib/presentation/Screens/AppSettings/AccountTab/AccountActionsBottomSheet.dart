import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';

class AccountActionsBottomSheet extends StatelessWidget {
  const AccountActionsBottomSheet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.vpn_key),
          title: Text('Change password'),
          onTap: () => Navigator.of(context).pop(AccountActionsBottomSheetResult.changePassword),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Change Display Name'),
          onTap: () => Navigator.of(context).pop(AccountActionsBottomSheetResult.changeDisplayName),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: FlatButton(
            child: Text('Delete Account'),
            textColor: Colors.red,
            onPressed: () => Navigator.of(context).pop(AccountActionsBottomSheetResult.deleteAccount),
          ),
        )
      ],
    );
  }
}
