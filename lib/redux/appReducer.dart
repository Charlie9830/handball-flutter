import './appState.dart';
import './actions.dart';

AppState appReducer(AppState state, dynamic action ) {
  if (action is SelectProject) {
    return state.copyWith(
      selectedProjectId: action.uid,
    );
  }

  if (action is SetUser) {
    return state.copyWith(
      user: action.user,
    );
  }

  return state;
}