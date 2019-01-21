import 'package:handball_flutter/containers/models/ProjectModel.dart';
import 'package:redux/redux.dart';
import './appState.dart';
import './appReducer.dart';

final initialAppState = AppState(
  projects: [ 
    ProjectModel(uid: 'a', name: 'Project A'),
    ProjectModel(uid: 'b', name: 'Project B'),
    ],
    selectedProjectId: '-1',
);

final appStore = new Store<AppState> (
  appReducer,
  initialState: initialAppState,
);