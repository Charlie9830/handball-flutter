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
    var filteredTasks = _filterTasks(action.uid, state.tasksByProject);
    var filteredTaskLists = _filterTaskLists(action.uid, state.taskListsByProject);

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

  if (action is ReceiveProject) {
    var projects = _mergeProject(state.projects, action.project);
    return state.copyWith(projects: projects);
  }

  if (action is ReceiveTasks) {
    var tasks = _smooshAndMergeTasks(
        state.tasksByProject, action.tasks, action.originProjectId);
    var tasksByProject = _updateTasksByProject(
        state.tasksByProject, action.tasks, action.originProjectId);
    var filteredTasks = _filterTasks(state.selectedProjectId, tasksByProject);

    return state.copyWith(
      tasks: tasks,
      filteredTasks: filteredTasks,
      tasksByProject: tasksByProject,
      selectedTaskEntity:
          _updateSelectedTaskEntity(state.selectedTaskEntity, tasks),
      projectIndicatorGroups: getProjectIndicatorGroups(tasks),
      inflatedProject: _buildInflatedProject(
          filteredTasks,
          state.filteredTaskLists,
          state.projects.firstWhere(
              (item) => item.uid == state.selectedProjectId,
              orElse: () => null)),
    );
  }

  if (action is ReceiveTaskLists) {
    var taskLists = _smooshAndMergeTaskLists(
        state.taskListsByProject, action.taskLists, action.originProjectId);
    var taskListsByProject = _updateTaskListsByProject(
        state.taskListsByProject, action.taskLists, action.originProjectId);
    var filteredTaskLists =
        _filterTaskLists(state.selectedProjectId, taskListsByProject);

    return state.copyWith(
      taskLists: taskLists,
      taskListsByProject: taskListsByProject,
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

  if (action is RemoveProjectEntities) {
    var projectId = action.projectId;
    var projects =
        state.projects.where((project) => project.uid != projectId).toList();
    var taskLists = state.taskLists
        .where((taskList) => taskList.project != projectId)
        .toList();
    var tasks = state.tasks.where((task) => task.project != projectId).toList();

    return state.copyWith(
      projects: projects,
      taskLists: taskLists,
      tasks: tasks,
      filteredTaskLists: _filterTaskLists(projectId, state.taskListsByProject),
      filteredTasks: _filterTasks(projectId, state.tasksByProject),
      selectedTaskEntity:
          _updateSelectedTaskEntity(state.selectedTaskEntity, tasks),
      projectIndicatorGroups: getProjectIndicatorGroups(tasks),
    );
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

_filterTaskLists(
    String projectId, Map<String, List<TaskListModel>> taskListsByProject) {
  return taskListsByProject[projectId] ?? <TaskListModel>[];
}

_filterTasks(String projectId, Map<String, List<TaskModel>> tasksByProject) {
  return tasksByProject[projectId] ?? <TaskModel>[];
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

List<ProjectModel> _mergeProject(
    List<ProjectModel> existingProjects, ProjectModel incomingProject) {
  if (existingProjects.length == 0) {
    print("Bailing Early");
    return <ProjectModel>[incomingProject];
  }

  List<ProjectModel> existingProjectsCopy = List.from(existingProjects);

  var existingIndex =
      existingProjects.indexWhere((item) => item.uid == incomingProject.uid);
  if (existingIndex != -1) {
    // Project already exists in original collection. Just Swap it out.
    existingProjectsCopy[existingIndex] = incomingProject;

    return existingProjectsCopy;
  }

  // Project doesn't already exist in original collection. Append it.
  existingProjectsCopy.add(incomingProject);
  return existingProjectsCopy;
}

List<TaskListModel> _smooshAndMergeTaskLists(
    Map<String, List<TaskListModel>> taskListsByProject,
    List<TaskListModel> newTaskLists,
    String originProjectId) {
  if (taskListsByProject.isEmpty) {
    return newTaskLists;
  }

  var list = <TaskListModel>[];
  taskListsByProject.forEach((key, value) {
    // If projectId matches originProjectId, replace with new TaskLists. Else use current tasksLists.
    list.addAll(
        key == originProjectId ? newTaskLists : taskListsByProject[key]);
  });

  return list;
}

List<TaskModel> _smooshAndMergeTasks(
    Map<String, List<TaskModel>> tasksByProject,
    List<TaskModel> newTasks,
    String originProjectId) {
  if (tasksByProject.isEmpty) {
    return newTasks;
  }

  var list = <TaskModel>[];
  tasksByProject.forEach((key, value) {
    // If projectId matches originProjectId, replace with new Tasks. Else use current tasks.
    list.addAll(key == originProjectId ? newTasks : tasksByProject[key]);
  });

  return list;
}

Map<String, List<TaskModel>> _updateTasksByProject(
    Map<String, List<TaskModel>> existingTasksByProject,
    List<TaskModel> newTasks,
    String originProjectId) {
  Map<String, List<TaskModel>> newMap = Map.from(existingTasksByProject);
  newMap[originProjectId] = newTasks;

  return newMap;
}

Map<String, List<TaskListModel>> _updateTaskListsByProject(
    Map<String, List<TaskListModel>> existingTaskListsByProject,
    List<TaskListModel> newTaskLists,
    String originProjectId) {
  Map<String, List<TaskListModel>> newMap =
      Map.from(existingTaskListsByProject);
  newMap[originProjectId] = newTaskLists;

  return newMap;
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
