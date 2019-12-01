import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/AppDrawerScreenViewModel.dart';
import 'package:handball_flutter/models/AppSettingsViewModel.dart';
import 'package:handball_flutter/models/AppTheme.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/TaskInspectorScreenViewModel.dart';
import 'package:handball_flutter/models/ThemeEditorViewModel.dart';
import 'package:handball_flutter/models/UpgradeToProViewDialogModel.dart';
import 'package:handball_flutter/presentation/Dialogs/UpgradeToProDialog/UpgradeToProDialog.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AppSettings.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/GeneralTab/ThemeEditor.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/TaskInspectorScreen.dart';

import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';

class UpgradeToProDialogContainer extends StatelessWidget {
  final AppSettingsTabs initialTab;
  
  UpgradeToProDialogContainer({
    this.initialTab,
  });

  Widget build(BuildContext context) {
    return new StoreConnector<AppState, UpgradeToProDialogViewModel> (
      converter: (Store<AppState> store) => _converter(store, context),
      builder: ( context, viewModel) {
        return new UpgradeToProDialog(viewModel: viewModel);
      },
    );
  }

  _converter(Store<AppState> store, BuildContext context) {
    return new UpgradeToProDialogViewModel(
      userId: store.state.user.userId,
    );
  }
}
