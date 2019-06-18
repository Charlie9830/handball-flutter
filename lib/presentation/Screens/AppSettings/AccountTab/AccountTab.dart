import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/AccountProgess.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/LoggedIn.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/LoggedOut.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/QuickAccountChanger.dart';

class AccountTab extends StatelessWidget {
  final User user;
  final AccountState accountState;
  final dynamic onSignIn;
  final dynamic onSignOut;
  final dynamic onSignUpButtonPressed;
  final dynamic onAccountChange;

  AccountTab({
    this.user,
    this.accountState,
    this.onSignIn,
    this.onSignOut,
    this.onSignUpButtonPressed,
    this.onAccountChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
          Expanded(
            child: _getChild(accountState),
          ),
          if (!kReleaseMode)
            QuickAccountChanger(onAccountChange: onAccountChange)
        ]));
  }

  Widget _getChild(AccountState accountState) {
    switch (accountState) {
      case AccountState.loggedOut:
        return LoggedOut(
          onSignIn: onSignIn,
          onSignUpButtonPressed: onSignUpButtonPressed,
        );

      case AccountState.loggingIn:
        return AccountProgress(activityName: 'Signing In');

      case AccountState.loggedIn:
        return LoggedIn(
          displayName: user.displayName ?? '',
          email: user.email ?? '',
          onSignOut: onSignOut,
        );

      case AccountState.registering:
        return AccountProgress(activityName: 'Creating Account');

      default:
        return Text("Uh oh, something went wrong");
    }
  }
}
