enum DialogResult { affirmative, negative }
enum ProjectType { local, shared }
enum DueDateType { unset, complete, later, soon, today, overdue }
enum DueDateChitSize { standard, small }

enum TaskSorting {
  auto,
  completed,
  priority,
  dueDate,
  dateAdded,
  assignee,
  alphabetically,
}
const defaultTaskSorting = TaskSorting.auto;

enum TaskListSorting { dateAdded, custom }
const defaultTaskListSorting = TaskListSorting.dateAdded;

enum AppSettingsTabs { general, account }
enum AccountState { loggedOut, loggingIn, loggedIn, registering }
enum ShareProjectScreenType { complete, simplified }
enum RemoteUserResultStatus { found, notFound }
enum MemberRole { member, owner }
enum MemberStatus { pending, added, denied, left, unjoined } // Unjoined denotes a member who has not signed up to the app yet.

enum TaskMetadataUpdateType { created, completed, updated }

enum TasksSnapshotType { completed, incompleted }

enum MaterialColorPickerType { primary, accent }

enum ActivityFeedQueryLength {
  day,
  week,
  twoWeek,
  month,
  threeMonth,
  sixMonth,
  year
}

// You serialize these by index, don't screw around with the order.
enum UndoActionType {
  deleteProject,
  deleteTaskList,
  deleteTask,
  completeTask,
  multiCompleteTasks,
  multiDeleteTasks,
}

// You serialize these by index, don't screw around with the order.
enum ActivityFeedEventType {
  addTask,
  deleteTask,
  completeTask,
  editTask,
  moveTask,
  unCompleteTask,
  commentOnTask, // Not implemented. Has the potentional to greatly increase the ammount of Database Writes and Reads.
  prioritizeTask,
  unPrioritizeTask,
  changeDueDate,
  addDetails,
  addList,
  moveList,
  deleteList,
  renameList,
  addMember,
  removeMember, // Not implemented. Not sure how I feel about a user being removed from the Project being gazzeted in the Activity Feed.
  addProject,
  renameProject,
  renewChecklist,
  assignmentUpdate,
  reColorList,
}

enum ThemeBrightness { light, dark, device }

enum TaskInspectorAssignmentInputType { normal, hidden, clearOnly }

enum AccountActionsBottomSheetResult {
  changePassword,
  changeDisplayName,
  deleteAccount,
  changeEmailAddress,
}

enum SplashScreenState {
  loading,
  onboarding,
  loggedOut,
  home,
}

enum DynamicLinkType {
  invalid,
  projectInvite,
}