import 'package:flutter/material.dart';
import 'package:handball_flutter/containers/ProjectScreenContainer.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/presentation/Dialogs/TextInputDialog.dart';
import 'package:handball_flutter/redux/actions.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';

void navigationMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) {
  next(action);

  if (action is NavigateToProject) {
    navigatorKey.currentState.push(new MaterialPageRoute(builder: (context) {
      return new ProjectScreenContainer();
    }));
  }

  if (action is NavigateToAppDrawer) {
    navigatorKey.currentState.pop();
  }
}
