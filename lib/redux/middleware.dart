import 'package:flutter/material.dart';
import 'package:handball_flutter/containers/AppSettingsContainer.dart';
import 'package:handball_flutter/containers/HomeScreenContainer.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/presentation/Dialogs/TextInputDialog.dart';
import 'package:handball_flutter/containers/TaskInspectorScreenContainer.dart';
import 'package:handball_flutter/redux/actions.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';

void navigationMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) {
  next(action);

  if (action is SelectProject) {
    navigatorKey.currentState.pop();
  }

  if (action is OpenAppSettings) {
    navigatorKey.currentState.push(
      new MaterialPageRoute(
        builder: (context) {
          return new AppSettingsContainer(
            initialTab: action.tab ?? AppSettingsTabs.general,
          );
        }
      )
    );
  }

  if (action is CloseAppSettings) {
    navigatorKey.currentState.pop();
  }

  if (action is OpenTaskInspector) {
    store.dispatch(SetSelectedTaskEntity(taskEntity: action.taskEntity));

    navigatorKey.currentState.push(
      new MaterialPageRoute(
        builder: (context) {
          return new TaskInspectorScreenContainer();
        }
      )
    );
  }

  if (action is CloseTaskInspector) {
    store.dispatch(SetSelectedTaskEntity(taskEntity: null));

    navigatorKey.currentState.pop();
  }
}
