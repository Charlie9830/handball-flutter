import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/User.dart';

class AppSettingsViewModel {
  final AppSettingsTabs initialTab;
  final User user;
  final AccountState accountState;
  final dynamic onClose;
  final dynamic onSignIn;
  final dynamic onSignOut;
  final dynamic onSignUpButtonPressed;

  AppSettingsViewModel({
    this.initialTab,
    this.user,
    this.accountState,
    this.onSignIn,
    this.onSignOut,
    this.onClose,
    this.onSignUpButtonPressed,
  });
}