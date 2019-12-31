import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/redux/syncActions.dart';
import 'package:handball_flutter/utilities/quickActionsLayer/quickActionsLayer.dart';
import 'package:redux/redux.dart';

void quickActionsMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) {
  next(action);

  if (action is ReceiveProject) {
    if (store.state.projectsById.containsKey(action.project.uid) &&
        action.project.projectName !=
            store.state.projectsById[action.project.uid].projectName) {
      // Project already exists within State, and the existing one has  different name so just update the Shortcut Name.
      QuickActionsLayer.updateProjectShortcut(
          action.project.uid, action.project.projectName);
    } else {
      // New Project.
      QuickActionsLayer.addProjectShortcut(
          action.project.uid, action.project.projectName);
    }
  }

  if (action is RemoveProjectEntities) {
    QuickActionsLayer.deleteProjectShortcut(action.projectId);
  }
}
