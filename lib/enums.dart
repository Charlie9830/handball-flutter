enum DialogResult { affirmative, negative }
enum ProjectType { local, shared }
enum DueDateType { unset, complete, later, soon, today, overdue }
enum DueDateChitSize { standard, small }

enum TaskSorting { completed, priority, dueDate, dateAdded, assignee, alphabetically }
const defaultTaskSorting = TaskSorting.dateAdded;

enum TaskListSorting { dateAdded, custom }
const defaultTaskListSorting = TaskListSorting.dateAdded;

enum AppSettingsTabs { general, account, about }
enum AccountState { loggedOut, loggingIn, loggedIn, registering }
enum ShareProjectScreenType { complete, simplified }
enum RemoteUserResultStatus { found, notFound}
enum MemberRole { member, owner }
enum MemberStatus { pending, added, denied }