import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/AccountActionsBottomSheet.dart';

class LoggedIn extends StatelessWidget {
  final String displayName;
  final String email;
  final dynamic onSignOut;
  final dynamic onDeleteAccount;
  final dynamic onChangeDisplayName;
  final dynamic onChangePassword;
  final dynamic onChangeEmailAddress;

  LoggedIn({
    this.displayName,
    this.email,
    this.onSignOut,
    this.onDeleteAccount,
    this.onChangeDisplayName,
    this.onChangePassword,
    this.onChangeEmailAddress
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 32),
      child: Column(
        children: <Widget>[
          Icon(Icons.person_outline, size: 40),
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 16),
            child: Text('Signed In',
                style: Theme.of(context).textTheme.headline),
          ),
          Padding(
              padding: EdgeInsets.only(top: 64, bottom: 64),
              child: Column(
                children: <Widget>[
                  Text(displayName, style: Theme.of(context).textTheme.subhead.copyWith(fontFamily: 'Ubuntu')),
                  Text(email, style: Theme.of(context).textTheme.subhead.copyWith(fontFamily: 'Ubuntu')),
                ],
              )),
          RaisedButton(
            child: Text('Sign Out'),
            onPressed: () => onSignOut(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: FlatButton(
              child: Text('Manage Account'),
              onPressed: () => _handleManageAccountButtonPress(context),
            ),
          )
        ],
      ),
    );
  }

  void _handleManageAccountButtonPress(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      builder: (context) => AccountActionsBottomSheet(),
    );

    if (result is AccountActionsBottomSheetResult) {
      switch (result) {
        case AccountActionsBottomSheetResult.changePassword:
          onChangePassword();
          break;

        case AccountActionsBottomSheetResult.changeDisplayName:
          onChangeDisplayName();
          break;

        case AccountActionsBottomSheetResult.deleteAccount:
          onDeleteAccount();
          break;

        case AccountActionsBottomSheetResult.changeEmailAddress:
          onChangeEmailAddress();
          break;
      }
    }
  }
}
