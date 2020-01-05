import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/AccountProgess.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/LoggedIn.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/LoggedOut.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/QuickAccountChanger.dart';

class AccountTab extends StatelessWidget {
  final UserModel user;
  final AccountState accountState;
  final dynamic onSignIn;
  final dynamic onSignOut;
  final dynamic onSignUpButtonPressed;
  final dynamic onAccountChange;
  final dynamic onDeleteAccount;

  AccountTab({
    this.user,
    this.accountState,
    this.onSignIn,
    this.onSignOut,
    this.onSignUpButtonPressed,
    this.onAccountChange,
    this.onDeleteAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        child: Column(children: <Widget>[
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Logged Out - We have to use a Visibility Widget to conditionally Render this so that we can maintain it's state, IE: What the user has already typed
              // after the attempt a Log in and this widget is hidden.
              Visibility(
                visible: accountState == AccountState.loggedOut,
                maintainState: true,
                child: LoggedOut(
                  onSignIn: onSignIn,
                  onSignUpButtonPressed: onSignUpButtonPressed,
                ),
              ),

              // Logged In.
              if (accountState == AccountState.loggedIn)
                LoggedIn(
                  displayName: user.displayName ?? '',
                  email: user.email ?? '',
                  onSignOut: onSignOut,
                  onDeleteAccount: onDeleteAccount,
                ),

              // Logging In
              if (accountState == AccountState.loggingIn)
                AccountProgress(activityName: 'Signing In'),

              // Registering.
              if (accountState == AccountState.registering)
                AccountProgress(activityName: 'Creating Account')
            ],
          )),
          if (!kReleaseMode)
            QuickAccountChanger(onAccountChange: onAccountChange)
        ]));
  }
}
