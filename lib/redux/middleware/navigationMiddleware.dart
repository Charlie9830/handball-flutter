import 'package:flutter/material.dart';
import 'package:handball_flutter/containers/ActivityFeedContainer.dart';
import 'package:handball_flutter/containers/AppSettingsContainer.dart';
import 'package:handball_flutter/containers/CommentScreenContainer.dart';
import 'package:handball_flutter/containers/ShareProjectContainer.dart';
import 'package:handball_flutter/containers/TaskInspectorScreenContainer.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/presentation/Screens/SplashScreen/SplashScreen.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/redux/asyncActions.dart';
import 'package:handball_flutter/redux/syncActions.dart';
import 'package:redux/redux.dart';

void navigationMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) {
  next(action);

  if (action is SelectProject) {
    if (homeScreenScaffoldKey?.currentState?.isDrawerOpen == true &&
        action.uid != '-1') {
      navigatorKey.currentState.pop();
    }
  }

  if (action is OpenActivityFeed) {
    navigatorKey.currentState.push(new MaterialPageRoute(builder: (context) {
      return new ActivityFeedContainer();
    }));
  }

  if (action is OpenAppSettings) {
    navigatorKey.currentState.push(new MaterialPageRoute(builder: (context) {
      return new AppSettingsContainer(
        initialTab: action.tab ?? AppSettingsTabs.general,
      );
    }));
  }

  if (action is OpenShareProjectScreen) {
    navigatorKey.currentState.push(new MaterialPageRoute(builder: (context) {
      return new ShareProjectContainer();
    }));
  }

  if (action is CloseAppSettings) {
    navigatorKey.currentState.pop();
  }

  if (action is OpenTaskInspector) {
    store.dispatch(SetSelectedTaskEntity(taskEntity: action.taskEntity));

    navigatorKey.currentState.push(new MaterialPageRoute(builder: (context) {
      return new TaskInspectorScreenContainer();
    }));
  }

  if (action is CloseTaskInspector) {
    store.dispatch(SetSelectedTaskEntity(taskEntity: null));

    navigatorKey.currentState.pop();
  }

  if (action is OpenTaskCommentsScreen) {
    navigatorKey.currentState.push(new MaterialPageRoute(builder: (context) {
      return CommentScreenContainer();
    }));
  }

  if (action is CloseTaskCommentsScreen) {
    navigatorKey.currentState.pop();
  }
}
