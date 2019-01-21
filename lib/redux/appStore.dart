import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import './appState.dart';
import './appReducer.dart';

final initialAppState = AppState(
  projects: [ 
    ProjectModel(uid: 'a', name: 'Project A'),
    ProjectModel(uid: 'b', name: 'Project B'),
    ],
    selectedProjectId: '-1',
    user: new User(
      isLoggedIn: false,
      displayName: '',
      userId: '-1',
      email: '',
    )
);

final appStore = new Store<AppState> (
  appReducer,
  initialState: initialAppState,
  middleware: [thunkMiddleware]
);