import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import './appState.dart';
import './appReducer.dart';
import './middleware.dart';

final initialAppState = AppState(
  tasks: <TaskModel>[],
  filteredTasks: <TaskModel>[],
  taskLists: <TaskListModel>[],
  filteredTaskLists: <TaskListModel>[],
  projects: [],
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
  middleware: [thunkMiddleware, navigationMiddleware]
);