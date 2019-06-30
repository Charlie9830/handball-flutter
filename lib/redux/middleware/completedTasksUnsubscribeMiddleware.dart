import 'package:flutter/material.dart';
import 'package:handball_flutter/containers/AppSettingsContainer.dart';
import 'package:handball_flutter/containers/CommentScreenContainer.dart';
import 'package:handball_flutter/containers/HomeScreenContainer.dart';
import 'package:handball_flutter/containers/ShareProjectContainer.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/presentation/Dialogs/TextInputDialog.dart';
import 'package:handball_flutter/containers/TaskInspectorScreenContainer.dart';
import 'package:handball_flutter/redux/actions.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';

void completedTasksUnsubscribeMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) {
  if (action is SelectProject && store.state.showCompletedTasks == true) {
    store.dispatch(setShowCompletedTasks(false, action.uid));
  }

  next(action);
}
