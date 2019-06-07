import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/AppSettingsViewModel.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/AboutTab.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/AccountTab.dart';

class AppSettings extends StatelessWidget {
  final AppSettingsViewModel viewModel;

  AppSettings({
    this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: _getInitialTabIndex(),
      child: Scaffold(
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
                Tab(text: 'About'),
              ],
            )),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Text('General'),
            AccountTab(
              accountState: viewModel.accountState,
              user: viewModel.user,
              onSignIn: viewModel.onSignIn,
              onSignOut: viewModel.onSignOut,
            ),
            AboutTab(),
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

      case AppSettingsTabs.about:
        return 2;

      default:
        return 0;
    }
  }
}
