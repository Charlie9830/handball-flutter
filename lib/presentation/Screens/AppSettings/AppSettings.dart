import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/models/AppSettingsViewModel.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/AccountTab.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/GeneralTab/GeneralTab.dart';

class AppSettings extends StatelessWidget {
  final AppSettingsViewModel viewModel;

  AppSettings({
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: _getInitialTabIndex(),
      child: Scaffold(
        key: appSettingsScaffoldKey,
        appBar: AppBar(            
            title: Text('Settings'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: viewModel.onClose,
            ),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(text: 'General'),
                Tab(text: 'Account'),
              ],
            )),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            GeneralTab(
              onViewArchivedProjectsTap: viewModel.onViewArchivedProjects,
            ),
            AccountTab(
              accountState: viewModel.accountState,
              user: viewModel.user,
              onSignIn: viewModel.onSignIn,
              onSignOut: viewModel.onSignOut,
              onSignUpButtonPressed: viewModel.onSignUpButtonPressed,
              onAccountChange: viewModel.onAccountChange,
              onDeleteAccount: viewModel.onDeleteAccount,
              onChangeDisplayName: viewModel.onChangeDisplayName,
              onChangePassword: viewModel.onChangePassword,
              onForgotPasswordButtonPressed: viewModel.onForgotPasswordButtonPressed,
              onChangeEmailAddress: viewModel.onChangeEmailAddress,
            ),
          ],
        ),
      ),
    );
  }

  int _getInitialTabIndex() {
    switch (viewModel.initialTab) {
      case AppSettingsTabs.general:
        return 0;

      case AppSettingsTabs.account:
        return 1;

      default:
        return 0;
    }
  }
}
