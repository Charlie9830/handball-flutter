import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/Comment.dart';
import 'package:handball_flutter/models/EnableState.dart';
import 'package:handball_flutter/models/IndicatorGroup.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/ProjectInvite.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/TextInputDialogModel.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:handball_flutter/redux/middleware/completedTasksUnsubscribeMiddleware.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';
import './appState.dart';
import './appReducer.dart';
import 'package:handball_flutter/redux/middleware/navigationMiddleware.dart';
import 'package:redux_logging/redux_logging.dart';

final initialAppState = AppState(
  tasks: <TaskModel>[],
  tasksByProject: <String, List<TaskModel>>{},
  taskLists: <TaskListModel>[],
  taskListsByProject: <String, List<TaskListModel>>{},
  projects: [],
  projectIndicatorGroups: <String, IndicatorGroup>{},
  selectedProjectId: '-1',
  projectShareMenuEntity: null,
  inflatedProject: null,
  selectedTaskEntity: null,
  focusedTaskListId: '-1',
  user: new User(
    isLoggedIn: false,
    displayName: '',
    userId: '-1',
    email: '',
  ),
  lastUsedTaskLists: <String, String>{},
  textInputDialog: TextInputDialogModel(
    isOpen: false,
    text: '',
    onOkay: (){},
    onCancel: (){},
  ),
  accountState: AccountState.loggedOut,
  projectInvites: <ProjectInviteModel>[],
  processingProjectInviteIds: <String>[],
  members: <String, List<MemberModel>>{},
  isInvitingUser: false,
  processingMembers: <String>[],
  listSorting: TaskListSorting.dateAdded,
  taskComments: <CommentModel>[],
  isTaskCommentPaginationComplete: false,
  isGettingTaskComments: false,
  isPaginatingTaskComments: false,
  multiSelectedTasks: <String, TaskModel>{},
  isInMultiSelectTaskMode: false,
  memberLookup: <String, MemberModel>{},
  showOnlySelfTasks: false,
  showCompletedTasks: false,
  incompletedTasksByProject: <String, List<TaskModel>>{},
  completedTasksByProject: <String, List<TaskModel>>{},
  accountConfig: null,
  enableState: EnableStateModel(),
);

final appStore = new Store<AppState> (
  appReducer,
  initialState: initialAppState,
  middleware: [thunkMiddleware, navigationMiddleware, completedTasksUnsubscribeMiddleware /* LoggingMiddleware.printer() */]
);