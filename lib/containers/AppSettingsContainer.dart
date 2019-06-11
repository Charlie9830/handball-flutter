import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/AppDrawerScreenViewModel.dart';
import 'package:handball_flutter/models/AppSettingsViewModel.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/TaskInspectorScreenViewModel.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AppSettings.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/TaskInspectorScreen.dart';
import 'package:handball_flutter/redux/actions.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';

class AppSettingsContainer extends StatelessWidget {
  final AppSettingsTabs initialTab;
  
  AppSettingsContainer({
    this.initialTab,
  });

  Widget build(BuildContext context) {
    return new StoreConnector<AppState, AppSettingsViewModel> (
      converter: (Store<AppState> store) => _converter(store, context),
      builder: ( context, viewModel) {
        return new AppSettings(viewModel: viewModel);
      },
    );
  }

  _converter(Store<AppState> store, BuildContext context) {
    return new AppSettingsViewModel(
      initialTab: initialTab,
      user: store.state.user,
      accountState: store.state.accountState,
      onSignIn: (email, password) => store.dispatch(signInUser(email, password, context)),
      onSignOut: () => store.dispatch(signOutUser()),
      onClose: () => store.dispatch(CloseAppSettings()),
      onSignUpButtonPressed: () => store.dispatch(showSignUpDialog(context))
    );
  }
}
