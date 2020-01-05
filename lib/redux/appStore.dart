import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/AccountConfig.dart';
import 'package:handball_flutter/models/ActivityFeedEventModel.dart';
import 'package:handball_flutter/models/Comment.dart';
import 'package:handball_flutter/models/EnableState.dart';
import 'package:handball_flutter/models/IndicatorGroup.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/ProjectIdModel.dart';
import 'package:handball_flutter/models/ProjectInvite.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/TextInputDialogModel.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:handball_flutter/redux/middleware/completedTasksUnsubscribeMiddleware.dart';
import 'package:handball_flutter/redux/middleware/navigationMiddleware.dart';
import 'package:handball_flutter/redux/middleware/quickActionsMiddleware.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_thunk/redux_thunk.dart';

import './appReducer.dart';
import './appState.dart';

final initialAppState = AppState(
  projectIds: <ProjectIdModel>[],
  tasks: <TaskModel>[],
  tasksByProject: <String, List<TaskModel>>{},
  taskLists: <TaskListModel>[],
  taskListsByProject: <String, List<TaskListModel>>{},
  projects: [],
  projectsById: <String, ProjectModel>{},
  activityFeed: <ActivityFeedEventModel>[],
  projectIndicatorGroups: <String, IndicatorGroup>{},
  selectedProjectId: '-1',
  projectShareMenuEntity: null,
  inflatedProject: null,
  selectedTaskEntity: null,
  focusedTaskListId: '-1',
  user: UserModel.fromDefault(),
  lastUsedTaskLists: <String, String>{},
  textInputDialog: TextInputDialogModel(
    isOpen: false,
    text: '',
    onOkay: () {},
    onCancel: () {},
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
  accountConfig: AccountConfigModel.fromDefault(),
  enableState: EnableStateModel(),
  lastUndoAction: null,
  tasksById: <String, TaskModel>{},
  deletedTaskLists: <String, TaskListModel>{},
  favirouteTaskListIds: <String, String>{},
  activityFeedQueryLength: ActivityFeedQueryLength.day,
  isRefreshingActivityFeed: false,
  selectedActivityFeedProjectId: '-1',
  canRefreshActivityFeed: false,
);

final appStore =
    new Store<AppState>(appReducer, initialState: initialAppState, middleware: [
  thunkMiddleware,
  navigationMiddleware,
  completedTasksUnsubscribeMiddleware,
  quickActionsMiddleware,
  // LoggingMiddleware.printer()
]);
