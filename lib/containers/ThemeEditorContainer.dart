import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/AppDrawerScreenViewModel.dart';
import 'package:handball_flutter/models/AppSettingsViewModel.dart';
import 'package:handball_flutter/models/AppTheme.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/TaskInspectorScreenViewModel.dart';
import 'package:handball_flutter/models/ThemeEditorViewModel.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AppSettings.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/GeneralTab/ThemeEditor.dart';
import 'package:handball_flutter/presentation/Screens/TaskInspector.dart/TaskInspectorScreen.dart';

import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/redux/asyncActions.dart';
import 'package:redux/redux.dart';

class ThemeEditorContainer extends StatelessWidget {
  final AppSettingsTabs initialTab;
  
  ThemeEditorContainer({
    this.initialTab,
  });

  Widget build(BuildContext context) {
    return new StoreConnector<AppState, ThemeEditorViewModel> (
      converter: (Store<AppState> store) => _converter(store, context),
      builder: ( context, viewModel) {
        return new ThemeEditor(viewModel: viewModel);
      },
    );
  }

  _converter(Store<AppState> store, BuildContext context) {
    return new ThemeEditorViewModel(
      isEnabled: store.state.accountConfig != null,
      data: store.state.accountConfig?.appTheme ?? AppThemeModel(),
      onThemeChanged: (newTheme) => store.dispatch(updateAppTheme(newTheme)),
    );
  }
}
