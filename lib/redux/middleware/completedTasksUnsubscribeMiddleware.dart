import 'package:handball_flutter/redux/actions.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';

void completedTasksUnsubscribeMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) {
  if (action is SelectProject &&
      store.state.showCompletedTasks == true &&
      store.state.selectedProjectId != '-1' &&
      store.state.selectedProjectId != null) {
    store.dispatch(setShowCompletedTasks(false, store.state.selectedProjectId));
  }

  next(action);
}
