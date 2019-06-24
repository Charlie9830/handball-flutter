import 'package:handball_flutter/models/InflatedProject.dart';
import 'package:handball_flutter/models/InflatedTaskList.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:handball_flutter/redux/appStore.dart';
import 'package:handball_flutter/utilities/getProjectIndicatorGroups.dart';
import 'package:meta/meta.dart';

import '../enums.dart';
import './appState.dart';
import './actions.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SelectProject) {
    var filteredTasks = _filterTasks(action.uid, state.tasksByProject);
    var filteredTaskLists =
        _filterTaskLists(action.uid, state.taskListsByProject);

    return state.copyWith(
        selectedProjectId: action.uid,
        filteredTasks: filteredTasks,
        filteredTaskLists: filteredTaskLists,
        inflatedProject: _buildInflatedProject(
          tasks: filteredTasks,
          taskLists: filteredTaskLists,
          project: _extractProject(action.uid, state.projects),
          listCustomSortOrder: _extractListCustomSortOrder(
              state.members, action.uid, state.user.userId),
          listSorting: state.listSorting,
        ));
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
        projectIndicatorGroups: getProjectIndicatorGroups(tasks, state.user.userId),
        inflatedProject: _buildInflatedProject(
          tasks: filteredTasks,
          taskLists: state.filteredTaskLists,
          project: _extractProject(state.selectedProjectId, state.projects),
          listCustomSortOrder: _extractListCustomSortOrder(
              state.members, state.selectedProjectId, state.user.userId),
          listSorting: state.listSorting,
        ));
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
          tasks: state.filteredTasks,
          taskLists: filteredTaskLists,
          project: _extractProject(state.selectedProjectId, state.projects),
          listCustomSortOrder: _extractListCustomSortOrder(
              state.members, state.selectedProjectId, state.user.userId),
          listSorting: state.listSorting,
        ));
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
    var members = Map<String, List<MemberModel>>.from(state.members)
      ..remove(projectId);

    return state.copyWith(
      selectedProjectId: '-1',
      inflatedProject: initialAppState.inflatedProject,
      projects: projects,
      taskLists: taskLists,
      tasks: tasks,
      filteredTaskLists: _filterTaskLists(projectId, state.taskListsByProject),
      filteredTasks: _filterTasks(projectId, state.tasksByProject),
      selectedTaskEntity:
          _updateSelectedTaskEntity(state.selectedTaskEntity, tasks),
      projectIndicatorGroups: getProjectIndicatorGroups(tasks, state.user.userId),
      members: members,
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
      projectInvites: initialAppState.projectInvites,
      processingProjectInviteIds: initialAppState.processingProjectInviteIds,
      members: initialAppState.members,
    );
  }

  if (action is OpenShareProjectScreen) {
    return state.copyWith(
      projectShareMenuEntity: state.projects.firstWhere(
          (project) => project.uid == action.projectId,
          orElse: () => null),
    );
  }

  if (action is ReceiveProjectInvites) {
    return state.copyWith(
      projectInvites: action.invites,
    );
  }

  if (action is SetProcessingProjectInviteIds) {
    return state.copyWith(
        processingProjectInviteIds: action.processingProjectInviteIds);
  }

  if (action is ReceiveMembers) {
    var members =
        _updateMembers(state.members, action.projectId, action.membersList);

    // Updating inflatedProject is expensive. So we will only do it here if we have to.
    var inflatedProject = action.projectId == state.selectedProjectId
        ? _buildInflatedProject(
            tasks: state.filteredTasks,
            taskLists: state.filteredTaskLists,
            project: _extractProject(state.selectedProjectId, state.projects),
            listCustomSortOrder: _extractListCustomSortOrder(
                members, state.selectedProjectId, state.user.userId),
            listSorting: state.listSorting)
        : state.inflatedProject;

    return state.copyWith(
      members: members,
      inflatedProject: inflatedProject
    );
  }

  if (action is SetIsInvitingUser) {
    return state.copyWith(
      isInvitingUser: action.isInvitingUser,
    );
  }

  if (action is SetListSorting) {
    var listSorting = action.listSorting;
    // Updating inflatedProject can be expensive. And we may be receiving this action from the initializeApp thunk
    // as it is drawing the ListSorting value from SharedPreferences.
    var inflatedProject = state.selectedProjectId != '-1'
        ? _buildInflatedProject(
            tasks: state.filteredTasks,
            taskLists: state.filteredTaskLists,
            project: _extractProject(state.selectedProjectId, state.projects),
            listCustomSortOrder: _extractListCustomSortOrder(
                state.members, state.selectedProjectId, state.user.userId),
            listSorting: listSorting)
        : state.inflatedProject;

    return state.copyWith(
        listSorting: listSorting,
        inflatedProject: inflatedProject);
  }

  if (action is ReceiveTaskComments) {
    return state.copyWith(
      taskComments: action.taskComments,
    );
  }

  if (action is SetIsTaskCommentPaginationComplete) {
    return state.copyWith(
      isTaskCommentPaginationComplete: action.isComplete,
    );
  }

  if (action is SetIsGettingTaskComments) {
    return state.copyWith(
      isGettingTaskComments: action.isGettingTaskComments,
    );
  }

  return state;
}

/*
  Helper Methods
*/
Map<String, List<MemberModel>> _updateMembers(
    Map<String, List<MemberModel>> existingMembersMap,
    String projectId,
    List<MemberModel> incomingMembersList) {
  var newMembersMap = Map<String, List<MemberModel>>.from(existingMembersMap);

  newMembersMap[projectId] = incomingMembersList;

  return newMembersMap;
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

ProjectModel _extractProject(String projectId, List<ProjectModel> projects) {
  return projects.firstWhere((item) => item.uid == projectId,
      orElse: () => null);
}

List<String> _extractListCustomSortOrder(
    Map<String, List<MemberModel>> members, String projectId, String userId) {
  if (projectId == '-1') {
    return null;
  }

  return members[projectId]
      ?.firstWhere((item) => item.userId == userId, orElse: () => null)
      ?.listCustomSortOrder;
}

InflatedProjectModel _buildInflatedProject(
    {@required List<TaskModel> tasks,
    @required List<TaskListModel> taskLists,
    @required ProjectModel project,
    @required TaskListSorting listSorting,
    @required List<String> listCustomSortOrder}) {
  if (project == null) {
    return null;
  }

  var sortedTaskLists =
      _sortTaskLists(listSorting, taskLists, listCustomSortOrder);

  var inflatedTaskLists = sortedTaskLists
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
      taskListSorting: listSorting,
      inflatedTaskLists: inflatedTaskLists,
      taskIndices: _buildTaskIndices(inflatedTaskLists));
}

int _taskListSorter(TaskListModel a, TaskListModel b) {
  int dateA = a.dateAdded?.millisecondsSinceEpoch ?? 0;
  int dateB = b.dateAdded?.millisecondsSinceEpoch ?? 0;

  return dateA - dateB;
}

List<TaskListModel> _sortTaskLists(TaskListSorting sorting,
    List<TaskListModel> taskLists, List<String> listCustomSortOrder) {
  var preSortedTaskLists = taskLists.toList()..sort(_taskListSorter);

  if (sorting == TaskListSorting.custom && listCustomSortOrder != null) {
    var idMap =
        _mapTaskListsById(taskLists); // Avoids running into O^n List lookups.

    var sortedTaskLists = <TaskListModel>[];
    // Prepend Task lists that haven't been given a Custom order by the User.
    for (var taskList in preSortedTaskLists) {
      if (listCustomSortOrder.contains(taskList.uid) == false) {
        sortedTaskLists.add(taskList);
      }
    }

    // Now add remaining TaskLists honoring the Custom Sorting Order.
    for (var id in listCustomSortOrder) {
      if (idMap.containsKey(id)) {
        sortedTaskLists.add(idMap[id]);
      }
    }

    return sortedTaskLists;
  } else {
    // No Custom Sorting. Sorted by Date added. Which we already did in the pre sort.
    return preSortedTaskLists;
  }
}

Map<String, TaskListModel> _mapTaskListsById(List<TaskListModel> taskLists) {
  return Map<String, TaskListModel>.fromIterable(taskLists,
      key: (item) {
        var taskList = item as TaskListModel;
        return taskList.uid;
      },
      value: (item) => item);
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
