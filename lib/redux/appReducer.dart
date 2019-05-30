import 'package:handball_flutter/models/InflatedProject.dart';
import 'package:handball_flutter/models/InflatedTaskList.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:handball_flutter/redux/appStore.dart';
import 'package:handball_flutter/utilities/getProjectIndicatorGroups.dart';

import '../enums.dart';
import './appState.dart';
import './actions.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SelectProject) {
    var filteredTasks = _filterTasks(action.uid, state.tasks);
    var filteredTaskLists = _filterTaskLists(action.uid, state.taskLists);

    return state.copyWith(
      selectedProjectId: action.uid,
      inflatedProject: _buildInflatedProject(
          filteredTasks,
          filteredTaskLists,
          state.projects.firstWhere((item) => item.uid == action.uid,
              orElse: () => null)),
      filteredTasks: filteredTasks,
      filteredTaskLists: filteredTaskLists,
    );
  }

  if (action is ReceiveLocalProjects) {
    return state.copyWith(projects: action.projects);
  }

  if (action is ReceiveLocalTasks) {
    var filteredTasks = _filterTasks(state.selectedProjectId, action.tasks);

    return state.copyWith(
      tasks: action.tasks,
      filteredTasks: filteredTasks,
      selectedTaskEntity:
          _updateSelectedTaskEntity(state.selectedTaskEntity, action.tasks),
      projectIndicatorGroups: getProjectIndicatorGroups(action.tasks),
      inflatedProject: _buildInflatedProject(
          filteredTasks,
          state.filteredTaskLists,
          state.projects.firstWhere(
              (item) => item.uid == state.selectedProjectId,
              orElse: () => null)),
    );
  }

  if (action is ReceiveLocalTaskLists) {
    var filteredTaskLists =
        _filterTaskLists(state.selectedProjectId, action.taskLists);

    return state.copyWith(
      taskLists: action.taskLists,
      filteredTaskLists: filteredTaskLists,
      inflatedProject: _buildInflatedProject(
          state.filteredTasks,
          filteredTaskLists,
          state.projects.firstWhere(
              (item) => item.uid == state.selectedProjectId,
              orElse: () => null)),
    );
  }

  if (action is SetFocusedTaskListId) {
    return state.copyWith(
      focusedTaskListId: action.taskListId,
    );
  }

  if (action is SetTextInputDialog) {
    return state.copyWith(textInputDialog: action.dialog);
  }

  if (action is SetSelectedTaskEntity) {
    return state.copyWith(selectedTaskEntity: action.taskEntity);
  }

  if (action is PushLastUsedTaskList) {
    var newMap = Map<String, String>.from(state.lastUsedTaskLists);
    newMap[action.projectId] = action.taskListId;
    return state.copyWith(
      lastUsedTaskLists: newMap,
    );
  }

  if (action is SignIn) {
    return state.copyWith(
      user: action.user,
      accountState: AccountState.loggedIn,
    );
  }

  if (action is SignOut) {
    return state.copyWith(
      user: User(
        displayName: '',
        email: '',
        userId: '',
        isLoggedIn: false,
      ),
      accountState: AccountState.loggedOut,
      tasks: initialAppState.tasks,
      filteredTasks: initialAppState.filteredTasks,
      taskLists: initialAppState.taskLists,
      filteredTaskLists: initialAppState.filteredTaskLists,
      projects: initialAppState.projects,
      projectIndicatorGroups: initialAppState.projectIndicatorGroups,
      selectedProjectId: initialAppState.selectedProjectId,
      inflatedProject: initialAppState.inflatedProject,
      selectedTaskEntity: initialAppState.selectedTaskEntity,
      focusedTaskListId: initialAppState.focusedTaskListId,
      lastUsedTaskLists: initialAppState.lastUsedTaskLists,
    );
  }

  return state;
}

_filterTaskLists(String projectId, List<TaskListModel> taskLists) {
  return taskLists.where((taskList) => taskList.project == projectId).toList();
}

_filterTasks(String projectId, List<TaskModel> tasks) {
  return tasks.where((task) => task.project == projectId).toList();
}

TaskModel _updateSelectedTaskEntity(
    TaskModel originalEntity, List<TaskModel> tasks) {
  if (originalEntity == null) {
    // No need to update.
    return null;
  }

  return tasks.firstWhere((task) => task.uid == originalEntity.uid,
      orElse: () => null);
}

InflatedProjectModel _buildInflatedProject(List<TaskModel> tasks,
    List<TaskListModel> taskLists, ProjectModel project) {
  if (project == null) {
    return null;
  }

  var inflatedTaskLists = taskLists
      .where((taskList) => taskList.project == project.uid)
      .map((taskList) {
    return InflatedTaskListModel(
      data: taskList,
      tasks: _sortTasks(tasks.where((task) => task.taskList == taskList.uid),
          taskList.settings.sortBy),
    );
  }).toList();

  return InflatedProjectModel(
      data: project,
      inflatedTaskLists: inflatedTaskLists,
      taskIndices: _buildTaskIndices(inflatedTaskLists));
}

Map<String, int> _buildTaskIndices(
    List<InflatedTaskListModel> inflatedTaskListModels) {
  var map = Map<String, int>();
  for (var taskList in inflatedTaskListModels) {
    int index = 0;
    for (var task in taskList.tasks) {
      map[task.uid] = index++;
    }
  }

  return map;
}

List<TaskModel> _sortTasks(Iterable<TaskModel> tasks, TaskSorting sorting) {
  switch (sorting) {
    case TaskSorting.completed:
      return List.from(tasks)..sort(_taskSorterCompleted);

    case TaskSorting.priority:
      return List.from(tasks)..sort(_taskSorterPriority);

    case TaskSorting.dueDate:
      return List.from(tasks)..sort(_taskDueDateSorter);

    case TaskSorting.dateAdded:
      return List.from(tasks)..sort(_taskDateAddedSorter);

    case TaskSorting.assignee:
      return List.from(tasks)..sort(_taskAssigneeSorter);

    case TaskSorting.alphabetically:
      return List.from(tasks)..sort(_taskSorterAlphabetical);

    default:
      return List.from(tasks);
  }
}

int _taskSorterAlphabetical(TaskModel a, TaskModel b) {
  return a.taskName.toUpperCase().compareTo(b.taskName.toUpperCase());
}

int _taskSorterCompleted(TaskModel a, TaskModel b) {
  if (a.isComplete) {
    return 1;
  }
  if (b.isComplete) {
    return -1;
  } else {
    return _taskDateAddedSorter(a, b);
  }
}

int _taskSorterPriority(TaskModel a, TaskModel b) {
  if (a.isHighPriority) {
    return -1;
  }
  if (b.isHighPriority) {
    return 1;
  } else {
    return _taskDateAddedSorter(a, b);
  }
}

int _taskDueDateSorter(TaskModel a, TaskModel b) {
  var dueDateA = a.dueDate == null ? 0 : a.dueDate.millisecondsSinceEpoch;
  var dueDateB = b.dueDate == null ? 0 : b.dueDate.millisecondsSinceEpoch;

  if (dueDateA < dueDateB) {
    return -1;
  }

  if (dueDateA > dueDateB) {
    return 1;
  }

  return _taskDateAddedSorter(a, b);
}

int _taskDateAddedSorter(TaskModel a, TaskModel b) {
  var dateAddedA = a.dateAdded == null ? 0 : a.dateAdded.millisecondsSinceEpoch;
  var dateAddedB = b.dateAdded == null ? 0 : b.dateAdded.millisecondsSinceEpoch;

  if (dateAddedA < dateAddedB) {
    return -1;
  }

  if (dateAddedA > dateAddedB) {
    return 0;
  }

  return 0;
}

int _taskAssigneeSorter(TaskModel a, TaskModel b) {
  var coercedA = a.assignedTo ?? '';
  var coercedB = b.assignedTo ?? '';

  return coercedA.compareTo(coercedB);
}
