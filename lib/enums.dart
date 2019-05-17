enum DialogResult { affirmative, negative }
enum ProjectType { local, shared }
enum DueDateType { unset, complete, later, soon, today, overdue }
enum DueDateChitSize { standard, small }

enum TaskSorting { completed, priority, dueDate, dateAdded, assignee, alphabetically }
const defaultTaskSorting = TaskSorting.dateAdded;