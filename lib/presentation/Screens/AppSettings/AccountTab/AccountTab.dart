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
  final dynamic onChangeDisplayName;
  final dynamic onChangePassword;
  final dynamic onForgotPasswordButtonPressed;

  AccountTab({
    this.user,
    this.accountState,
    this.onSignIn,
    this.onSignOut,
    this.onSignUpButtonPressed,
    this.onAccountChange,
    this.onDeleteAccount,
    this.onChangeDisplayName,
    this.onChangePassword,
    this.onForgotPasswordButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
      Visibility(
        visible: accountState == AccountState.loggedOut,
        maintainState: true,
        child: LoggedOut(
          onSignIn: onSignIn,
          onSignUpButtonPressed: onSignUpButtonPressed,
          onForgotPasswordButtonPressed: onForgotPasswordButtonPressed,
        ),
      ),

      // Logged In.
      if (accountState == AccountState.loggedIn)
        LoggedIn(
          displayName: user.displayName ?? '',
          email: user.email ?? '',
          onSignOut: onSignOut,
          onDeleteAccount: onDeleteAccount,
          onChangeDisplayName: onChangeDisplayName,
          onChangePassword: onChangePassword,
        ),

      // Logging In
      if (accountState == AccountState.loggingIn)
        AccountProgress(activityName: 'Signing In'),

      // Registering.
      if (accountState == AccountState.registering)
        AccountProgress(activityName: 'Creating Account'),

      // Debug Quick Account Switching.
      if (!kReleaseMode)
        QuickAccountChanger(onAccountChange: onAccountChange)
    ]);
  }
}
