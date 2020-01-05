import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/User.dart';

class AppSettingsViewModel {
  final AppSettingsTabs initialTab;
  final UserModel user;
  final AccountState accountState;
  final dynamic onClose;
  final dynamic onSignIn;
  final dynamic onSignOut;
  final dynamic onSignUpButtonPressed;
  final dynamic onAccountChange;
  final dynamic onViewArchivedProjects;
  final dynamic onDeleteAccount;

  AppSettingsViewModel({
    this.initialTab,
    this.user,
    this.accountState,
    this.onSignIn,
    this.onSignOut,
    this.onClose,
    this.onSignUpButtonPressed,
    this.onAccountChange,
    this.onViewArchivedProjects,
    this.onDeleteAccount,
  });
}