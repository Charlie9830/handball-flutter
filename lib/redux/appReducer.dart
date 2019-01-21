import './appState.dart';
import './actions.dart';

AppState appReducer(AppState state, dynamic action ) {
  if (action is SelectProject) {
    return state.copyWith(
      selectedProjectId: action.uid,
    );
  }

  return state;
}