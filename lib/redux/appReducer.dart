import 'package:handball_flutter/models/InflatedProject.dart';
import 'package:handball_flutter/models/InflatedTaskList.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:handball_flutter/redux/appStore.dart';
import 'package:handball_flutter/utilities/buildInflatedProject.dart';
import 'package:handball_flutter/utilities/extractListCustomSortOrder.dart';
import 'package:handball_flutter/utilities/extractProject.dart';
import 'package:handball_flutter/utilities/getProjectIndicatorGroups.dart';
import 'package:meta/meta.dart';

import '../enums.dart';
import './appState.dart';
import './actions.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SelectProject) {
    if (state.selectedProjectId == action.uid) {
      return state;
    }

    var filteredTasks = _filterTasks(action.uid, state.tasksByProject);
    var filteredTaskLists =
        _filterTaskLists(action.uid, state.taskListsByProject);

    return state.copyWith(
      selectedProjectId: action.uid,
      inflatedProject: buildInflatedProject(
          tasks: filteredTasks,
          taskLists: filteredTaskLists,
          project: extractProject(action.uid, state.projects),
          listCustomSortOrder: extractListCustomSortOrder(
              state.members, action.uid, state.user.userId),
          listSorting: state.listSorting,
          showOnlySelfTasks: false // Assert this mode to Off.
          ),
      showOnlySelfTasks: false,
      isInMultiSelectTaskMode: false,
      multiSelectedTasks: initialAppState.multiSelectedTasks,
    );
  }

  if (action is ReceiveProject) {
    var projects = _mergeProject(state.projects, action.project);
    return state.copyWith(projects: projects);
  }

  if (action is SetInflatedProject) {
    var inflatedProject =
        state.selectedProjectId == action.inflatedProject.data.uid
            ? action.inflatedProject
            : state.inflatedProject;

    return state.copyWith(
      inflatedProject: inflatedProject,
    );
  }

  if (action is SetShowOnlySelfTasks) {
    return state.copyWith(showOnlySelfTasks: action.showOnlySelfTasks);
  }

  if (action is ReceiveTasks) {
    var incompletedTasksByProject = action.type == TasksSnapshotType.incompleted
        ? _getUpdatedTasksByProject(state.incompletedTasksByProject,
            action.tasks, action.originProjectId)
        : state.incompletedTasksByProject;

    var completedTasksByProject = action.type == TasksSnapshotType.completed
        ? _getUpdatedTasksByProject(
            state.completedTasksByProject, action.tasks, action.originProjectId)
        : state.completedTasksByProject;

    var tasksByProject = _concatTasksByProject(state.projects, incompletedTasksByProject, completedTasksByProject);

    var allTasks = tasksByProject.values.expand((i) => i).toList();

    var inflatedProject = action.originProjectId == state.selectedProjectId
        ? buildInflatedProject(
            tasks: tasksByProject[state.selectedProjectId],
            taskLists: state.taskListsByProject[state.selectedProjectId],
            project: extractProject(state.selectedProjectId, state.projects),
            listCustomSortOrder: extractListCustomSortOrder(
                state.members, state.selectedProjectId, state.user.userId),
            listSorting: state.listSorting,
            showOnlySelfTasks: state.showOnlySelfTasks)
        : state.inflatedProject;

    return state.copyWith(
      tasks: allTasks,
      completedTasksByProject:
          initialAppState.completedTasksByProject, //completedTasksByProject,
      incompletedTasksByProject: incompletedTasksByProject,
      tasksByProject: tasksByProject,
      inflatedProject: inflatedProject,
      selectedTaskEntity:
          _updateSelectedTaskEntity(state.selectedTaskEntity, allTasks),
      projectIndicatorGroups:
          getProjectIndicatorGroups(allTasks, state.user.userId),
    );
  }

  if (action is ReceiveTaskLists) {
    var taskLists = _smooshAndMergeTaskLists(
        state.taskListsByProject, action.taskLists, action.originProjectId);
    var taskListsByProject = _updateTaskListsByProject(
        state.taskListsByProject, action.taskLists, action.originProjectId);

    var inflatedProject = state.selectedProjectId == action.originProjectId
        ? buildInflatedProject(
            tasks: state.tasksByProject[state.selectedProjectId],
            taskLists: taskListsByProject[action.originProjectId],
            project: extractProject(state.selectedProjectId, state.projects),
            listCustomSortOrder: extractListCustomSortOrder(
                state.members, state.selectedProjectId, state.user.userId),
            listSorting: state.listSorting,
            showOnlySelfTasks: state.showOnlySelfTasks)
        : state.inflatedProject;

    return state.copyWith(
        taskLists: taskLists,
        taskListsByProject: taskListsByProject,
        inflatedProject: inflatedProject);
  }

  if (action is AddMultiSelectedTask) {
    if (action.task == null) {
      return state;
    }

    var newMap = Map<String, TaskModel>.from(state.multiSelectedTasks);
    newMap[action.task.uid] = action.task;
    return state.copyWith(
      multiSelectedTasks: newMap,
    );
  }

  if (action is RemoveMultiSelectedTask) {
    if (action.task == null) {
      return state;
    }

    return state.copyWith(
      multiSelectedTasks: Map<String, TaskModel>.from(state.multiSelectedTasks)
        ..remove(action.task.uid),
    );
  }

  if (action is SetIsInMultiSelectTaskMode) {
    // Clear MultiSelectedTasks if we are leaving MultiSelectTaskMode.
    var multiSelectedTasks = action.isInMultiSelectTaskMode == true
        ? state.multiSelectedTasks
        : initialAppState.multiSelectedTasks;

    if (action.isInMultiSelectTaskMode == true &&
        action.initialSelection != null) {
      // Add the initial Selection.
      multiSelectedTasks = Map<String, TaskModel>.from(multiSelectedTasks);
      multiSelectedTasks[action.initialSelection.uid] = action.initialSelection;
    }

    return state.copyWith(
      isInMultiSelectTaskMode: action.isInMultiSelectTaskMode,
      multiSelectedTasks: multiSelectedTasks,
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
    var members = Map<String, List<MemberModel>>.from(state.members)
      ..remove(projectId);

    return state.copyWith(
      selectedProjectId: '-1',
      inflatedProject: initialAppState.inflatedProject,
      projects: projects,
      taskLists: taskLists,
      tasks: tasks,
      selectedTaskEntity:
          _updateSelectedTaskEntity(state.selectedTaskEntity, tasks),
      projectIndicatorGroups:
          getProjectIndicatorGroups(tasks, state.user.userId),
      members: members,
    );
  }

  if (action is SetShowCompletedTasks) {
    return state.copyWith(
      showCompletedTasks: action.showCompletedTasks,
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
      taskLists: initialAppState.taskLists,
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
      memberLookup: initialAppState.memberLookup,
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

    var inflatedProject = action.projectId == state.selectedProjectId
        ? buildInflatedProject(
            tasks: state.tasksByProject[state.selectedProjectId],
            taskLists: state.taskListsByProject[state.selectedProjectId],
            project: extractProject(state.selectedProjectId, state.projects),
            listCustomSortOrder: extractListCustomSortOrder(
                members, state.selectedProjectId, state.user.userId),
            listSorting: state.listSorting,
            showOnlySelfTasks: state.showOnlySelfTasks)
        : state.inflatedProject;

    return state.copyWith(
        members: members,
        memberLookup:
            _updateMemberLookup(state.memberLookup, action.membersList),
        inflatedProject: inflatedProject);
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
        ? buildInflatedProject(
            tasks: state.tasksByProject[state.selectedProjectId],
            taskLists: state.taskListsByProject[state.selectedProjectId],
            project: extractProject(state.selectedProjectId, state.projects),
            listCustomSortOrder: extractListCustomSortOrder(
                state.members, state.selectedProjectId, state.user.userId),
            listSorting: listSorting,
            showOnlySelfTasks: state.showOnlySelfTasks)
        : state.inflatedProject;

    return state.copyWith(
        listSorting: listSorting, inflatedProject: inflatedProject);
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

Map<String, MemberModel> _updateMemberLookup(
    Map<String, MemberModel> existingMemberLookup,
    List<MemberModel> incomingMembers) {
  var map = Map<String, MemberModel>.from(existingMemberLookup);

  for (var member in incomingMembers) {
    map[member.userId] = member;
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
    return newTasks.toList();
  }

  print('Smooshing');
  var list = <TaskModel>[];
  tasksByProject.forEach((key, value) {
    // If projectId matches originProjectId, use newTasks otherwise use the existing tasks.
    if (key == originProjectId) {
      print('Using new Tasks');
      list.addAll(newTasks);
    } else {
      print('Using Existing Tasks');
      list.addAll(tasksByProject[key]);
    }

    // list.addAll(key == originProjectId ? newTasks : tasksByProject[key]);
  });

  return list;
}

Map<String, List<TaskModel>> _concatTasksByProject(
    List<ProjectModel> projects,
    Map<String, List<TaskModel>> incompletedTasksByProject,
    Map<String, List<TaskModel>> completedTasksByProject) {
      var projectIds = projects.map( (item) => item.uid);

      var newMap = <String, List<TaskModel>>{};

      for (var id in projectIds) {
        newMap[id] = List<TaskModel>.from(incompletedTasksByProject[id] ?? <TaskModel>[])..addAll(completedTasksByProject[id] ?? <TaskModel>[]);
      }

      return newMap;
    }

Map<String, List<TaskModel>> _getUpdatedTasksByProject(
    Map<String, List<TaskModel>> existingTasksByProject,
    List<TaskModel> newTasks,
    String originProjectId) {
  Map<String, List<TaskModel>> newMap = Map.from(existingTasksByProject);
  newMap[originProjectId] = newTasks.toList();

  return newMap;
}

Map<String, List<TaskListModel>> _updateTaskListsByProject(
    Map<String, List<TaskListModel>> existingTaskListsByProject,
    List<TaskListModel> newTaskLists,
    String originProjectId) {
  Map<String, List<TaskListModel>> newMap =
      Map.from(existingTaskListsByProject);
  newMap[originProjectId] = newTaskLists.toList();

  return newMap;
}
