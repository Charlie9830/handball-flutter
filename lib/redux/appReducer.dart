import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/ActivityFeedEventModel.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/UndoActions/NoAction.dart';
import 'package:handball_flutter/models/User.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/redux/appStore.dart';
import 'package:handball_flutter/redux/syncActions.dart';
import 'package:handball_flutter/utilities/buildInflatedProject.dart';
import 'package:handball_flutter/utilities/extractListCustomSortOrder.dart';
import 'package:handball_flutter/utilities/extractProject.dart';
import 'package:handball_flutter/utilities/foldTasksTogether.dart';
import 'package:handball_flutter/utilities/getProjectIndicatorGroups.dart';
import 'package:handball_flutter/utilities/mergeLastUsedTaskList.dart';
import 'package:quiver/core.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is SelectProject) {
    if (state.selectedProjectId == action.uid) {
      return state;
    }

    var projectTasks = state.incompletedTasksByProject[action.uid];
    var projectTaskLists = state.taskListsByProject[action.uid];

    var inflatedProject = action.uid != '-1'
        ? buildInflatedProject(
            tasks: projectTasks,
            taskLists: projectTaskLists,
            project: extractProject(action.uid, state.projects),
            listCustomSortOrder: extractListCustomSortOrder(
                state.members, action.uid, state.user.userId),
            listSorting: state.listSorting,
            showOnlySelfTasks: false // Assert this mode to Off.
            )
        : state.inflatedProject;

    return state.copyWith(
      selectedProjectId: action.uid,
      inflatedProject: Optional.fromNullable(inflatedProject),
      showCompletedTasks: false, // Assert showCompletedTasks Off.
      showOnlySelfTasks: false,
      isInMultiSelectTaskMode: false,
      multiSelectedTasks: initialAppState.multiSelectedTasks,
      enableState: state.enableState.copyWith(
          isProjectSelected: action.uid != '-1' && action.uid != null
              ? true
              : state.enableState.isProjectSelected,
          showSelectAProjectHint: action.uid == '-1' ||
              action.uid == null && state.projects.length > 0,
          showNoProjectsHint: state.projects.length == 0,
          showNoTaskListsHint:
              projectTaskLists == null || projectTaskLists.length == 0,
          showSingleListNoTasksHint: projectTaskLists != null &&
              projectTaskLists.length == 1 &&
              projectTasks.length == 0,
          canArchiveProject: action.uid != '-1' && action.uid != null),
    );
  }

  if (action is ReceiveProjectIds) {
    return state.copyWith(
      projectIds: action.projectIds,
    );
  }

  if (action is ReceiveProject) {
    final projects = _mergeProject(state.projects, action.project);
    final isSelectedProjectIdValid =
        projects.indexWhere((item) => item.uid == state.selectedProjectId) !=
            -1;

    // Coerce inflatedProject.
    var inflatedProject =
        state.selectedProjectId == '-1' || isSelectedProjectIdValid == false
            ? null
            : state.inflatedProject;

    final projectsById = Map<String, ProjectModel>.from(state.projectsById);
    projectsById[action.project.uid] = action.project;

    return state.copyWith(
        projects: projects,
        selectedProjectId: state.selectedProjectId,
        projectsById: projectsById,
        inflatedProject: Optional.fromNullable(inflatedProject),
        enableState: state.enableState.copyWith(
          isProjectSelected:
              state.selectedProjectId != '-1' && isSelectedProjectIdValid,
          showNoProjectsHint: projects.length == 0,
          showSelectAProjectHint: projects.length > 0 &&
              (state.selectedProjectId == '-1' ||
                  state.selectedProjectId == null),
          canMoveTaskList: projects.length > 1,
        ));
  }

  if (action is SetInflatedProject) {
    var inflatedProject =
        state.selectedProjectId == action.inflatedProject.data.uid
            ? action.inflatedProject
            : state.inflatedProject;

    return state.copyWith(
      inflatedProject: Optional.fromNullable(inflatedProject),
    );
  }

  if (action is SetShowOnlySelfTasks) {
    return state.copyWith(showOnlySelfTasks: action.showOnlySelfTasks);
  }

  if (action is ReceiveAccountConfig) {
    return state.copyWith(
      accountConfig: Optional.fromNullable(action.accountConfig),
    );
  }

  if (action is ReceiveCompletedTasks) {
    var foldedTasks = foldTasksTogether(TasksSnapshotType.completed,
        action.tasks, action.originProjectId, state);

    var inflatedProject = action.originProjectId == state.selectedProjectId
        ? buildInflatedProject(
            tasks: foldedTasks.tasksByProject[state.selectedProjectId],
            taskLists: state.taskListsByProject[state.selectedProjectId],
            project: extractProject(state.selectedProjectId, state.projects),
            listCustomSortOrder: extractListCustomSortOrder(
                state.members, state.selectedProjectId, state.user.userId),
            listSorting: state.listSorting,
            showOnlySelfTasks: state.showOnlySelfTasks)
        : state.inflatedProject;

    return state.copyWith(
        tasks: foldedTasks.allTasks,
        tasksById: _buildTasksById(foldedTasks.allTasks),
        completedTasksByProject: foldedTasks.completedTasksByProject,
        incompletedTasksByProject: foldedTasks.incompletedTasksByProject,
        tasksByProject: foldedTasks.tasksByProject,
        inflatedProject: Optional.fromNullable(inflatedProject),
        selectedTaskEntity: _updateSelectedTaskEntity(
            state.selectedTaskEntity, foldedTasks.allTasks),
        projectIndicatorGroups: getProjectIndicatorGroups(
            foldedTasks.allTasks, state.deletedTaskLists, state.user.userId),
        enableState: state.enableState.copyWith(
            showSingleListNoTasksHint:
                state.taskListsByProject[state.selectedProjectId].length == 1 &&
                    foldedTasks
                            .tasksByProject[state.selectedProjectId].length ==
                        0));
  }

  if (action is ReceiveIncompletedTasks) {
    var foldedTasks = foldTasksTogether(TasksSnapshotType.incompleted,
        action.tasks, action.originProjectId, state);

    var inflatedProject = action.originProjectId == state.selectedProjectId
        ? buildInflatedProject(
            tasks: foldedTasks.tasksByProject[state.selectedProjectId],
            taskLists: state.taskListsByProject[state.selectedProjectId],
            project: extractProject(state.selectedProjectId, state.projects),
            listCustomSortOrder: extractListCustomSortOrder(
                state.members, state.selectedProjectId, state.user.userId),
            listSorting: state.listSorting,
            showOnlySelfTasks: state.showOnlySelfTasks)
        : state.inflatedProject;

    return state.copyWith(
        tasks: foldedTasks.allTasks,
        tasksById: _buildTasksById(foldedTasks.allTasks),
        completedTasksByProject: foldedTasks.completedTasksByProject,
        incompletedTasksByProject: foldedTasks.incompletedTasksByProject,
        tasksByProject: foldedTasks.tasksByProject,
        inflatedProject: Optional.fromNullable(inflatedProject),
        selectedTaskEntity: _updateSelectedTaskEntity(
            state.selectedTaskEntity, foldedTasks.allTasks),
        projectIndicatorGroups: getProjectIndicatorGroups(
            foldedTasks.allTasks, state.deletedTaskLists, state.user.userId),
        enableState: state.enableState.copyWith(
            showSingleListNoTasksHint: state
                        .taskListsByProject[state.selectedProjectId] !=
                    null &&
                state.taskListsByProject[state.selectedProjectId].length == 1 &&
                foldedTasks.tasksByProject[state.selectedProjectId].length ==
                    0));
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
        projectIndicatorGroups: getProjectIndicatorGroups(
            state.tasks,
            state.deletedTaskLists,
            state.user.userId), // TODO: Is this really required?
        // due to how ReceiveDeletedTaskLists works, in theory this is useless because if a list is undeleted, it will fire the ReceiveDeletedTaskLists and that
        // will show the relevent indicators again.
        inflatedProject: Optional.fromNullable(inflatedProject),
        enableState: state.enableState.copyWith(
            showNoTaskListsHint:
                taskListsByProject[state.selectedProjectId] != null &&
                    taskListsByProject[state.selectedProjectId].length == 0,
            showSingleListNoTasksHint:
                taskListsByProject[state.selectedProjectId] != null &&
                    taskListsByProject[state.selectedProjectId].length == 1 &&
                    state.tasksByProject[state.selectedProjectId] != null &&
                    state.tasksByProject[state.selectedProjectId].length == 0));
  }

  if (action is ReceiveDeletedTaskLists) {
    var newDeletedTaskListMap = _updateDeletedTaskLists(
        state.deletedTaskLists, action.taskLists, action.originProjectId);

    return state.copyWith(
        deletedTaskLists: newDeletedTaskListMap,
        projectIndicatorGroups: getProjectIndicatorGroups(
            state.tasks, newDeletedTaskListMap, state.user.userId));
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
    return state.copyWith(
        selectedTaskEntity: Optional.fromNullable(action.taskEntity));
  }

  if (action is RemoveProjectEntities) {
    final projectId = action.projectId;
    final didDeleteSelectedProject = projectId == state.selectedProjectId;
    final selectedProjectId =
        didDeleteSelectedProject ? '-1' : state.selectedProjectId;
    final inflatedProject = didDeleteSelectedProject
        ? initialAppState.inflatedProject
        : state.inflatedProject;

    final projectsById = Map<String, ProjectModel>.from(state.projectsById)
      ..remove(projectId);

    final projects =
        state.projects.where((project) => project.uid != projectId).toList();
    final taskLists = state.taskLists
        .where((taskList) => taskList.project != projectId)
        .toList();
    final taskListsByProject = Map<String, List<TaskListModel>>.from(
        state.taskListsByProject..remove(projectId));

    final tasks =
        state.tasks.where((task) => task.project != projectId).toList();
    final tasksByProject = Map<String, List<TaskModel>>.from(
        state.tasksByProject..remove(projectId));
    final incompletedTasksByProject = Map<String, List<TaskModel>>.from(
        state.incompletedTasksByProject..remove(projectId));
    final completedTasksByProject = Map<String, List<TaskModel>>.from(
        state.completedTasksByProject..remove(projectId));
    final tasksById = Map<String, TaskModel>.from(state.tasksById
      ..removeWhere((key, value) => value.project == projectId));

    final members = Map<String, List<MemberModel>>.from(state.members)
      ..remove(projectId);

    return state.copyWith(
        selectedProjectId: selectedProjectId,
        inflatedProject: Optional.fromNullable(inflatedProject),
        projects: projects,
        projectsById: projectsById,
        taskLists: taskLists,
        taskListsByProject: taskListsByProject,
        tasks: tasks,
        tasksById: tasksById,
        tasksByProject: tasksByProject,
        incompletedTasksByProject: incompletedTasksByProject,
        completedTasksByProject: completedTasksByProject,
        selectedTaskEntity:
            _updateSelectedTaskEntity(state.selectedTaskEntity, tasks),
        projectIndicatorGroups: getProjectIndicatorGroups(
            tasks, state.deletedTaskLists, state.user.userId),
        members: members,
        enableState: state.enableState.copyWith(
          canArchiveProject: selectedProjectId != '-1',
          isProjectSelected: didDeleteSelectedProject == false,
          showNoProjectsHint: projects.length == 0,
          showSelectAProjectHint:
              selectedProjectId == '-1' && projects.length != 0,
        ));
  }

  if (action is SetShowCompletedTasks) {
    return state.copyWith(
      showCompletedTasks: action.showCompletedTasks,
    );
  }

  if (action is PushLastUsedTaskList) {
    return state.copyWith(
      lastUsedTaskLists: mergeLastUsedTaskList(
          state.lastUsedTaskLists, action.projectId, action.taskListId),
    );
  }

  if (action is SetLastUsedTaskLists) {
    return state.copyWith(
      lastUsedTaskLists: action.value,
    );
  }

  if (action is SignIn) {
    return state.copyWith(
        user: action.user,
        accountState: AccountState.loggedIn,
        enableState: state.enableState.copyWith(
          isLoggedIn: true,
        ));
  }

  if (action is SignOut) {
    return state.copyWith(
        user: UserModel(
          displayName: '',
          email: '',
          userId: '',
          isLoggedIn: false,
        ),
        projectIds: initialAppState.projectIds,
        accountState: AccountState.loggedOut,
        tasks: initialAppState.tasks,
        tasksByProject: initialAppState.tasksByProject,
        completedTasksByProject: initialAppState.completedTasksByProject,
        incompletedTasksByProject: initialAppState.incompletedTasksByProject,
        taskLists: initialAppState.taskLists,
        taskListsByProject: initialAppState.taskListsByProject,
        projects: initialAppState.projects,
        projectsById: initialAppState.projectsById,
        projectIndicatorGroups: initialAppState.projectIndicatorGroups,
        selectedProjectId: initialAppState.selectedProjectId,
        inflatedProject: Optional.fromNullable(initialAppState.inflatedProject),
        selectedTaskEntity:
            Optional.fromNullable(initialAppState.selectedTaskEntity),
        focusedTaskListId: initialAppState.focusedTaskListId,
        lastUsedTaskLists: initialAppState.lastUsedTaskLists,
        projectInvites: initialAppState.projectInvites,
        processingProjectInviteIds: initialAppState.processingProjectInviteIds,
        members: initialAppState.members,
        memberLookup: initialAppState.memberLookup,
        showCompletedTasks: initialAppState.showCompletedTasks,
        showOnlySelfTasks: initialAppState.showOnlySelfTasks,
        accountConfig: Optional.fromNullable(initialAppState.accountConfig.copyWith(appTheme: state.accountConfig.appTheme)), // Hold onto the current Theme.
        activityFeed: initialAppState.activityFeed,
        enableState: state.enableState.copyWith(
          isLoggedIn: false,
        ));
  }

  if (action is CloseActivityFeed) {
    return state.copyWith(
      activityFeed: <ActivityFeedEventModel>[],
      activityFeedQueryLength: ActivityFeedQueryLength.day,
      selectedActivityFeedProjectId: '-1',
      isRefreshingActivityFeed: false,
      canRefreshActivityFeed: false,
    );
  }

  if (action is OpenShareProjectScreen) {
    return state.copyWith(
        projectShareMenuEntity: Optional.fromNullable(
      state.projects.firstWhere((project) => project.uid == action.projectId,
          orElse: () => null),
    ));
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

  if (action is ReceiveActivityFeed) {
    return state.copyWith(
        activityFeed:
            _filterActivityFeedEvents(action.activityFeed, state.projectsById));
  }

  if (action is SetCanRefreshActivityFeed) {
    return state.copyWith(
      canRefreshActivityFeed: action.canRefresh,
    );
  }

  if (action is SetActivityFeedQueryLength) {
    return state.copyWith(
      activityFeedQueryLength: action.length,
      canRefreshActivityFeed:
          action.isUserInitiated == true ? true : state.canRefreshActivityFeed,
    );
  }

  if (action is SetSelectedActivityFeedProjectId) {
    return state.copyWith(
      selectedActivityFeedProjectId: action.projectId,
      canRefreshActivityFeed:
          action.isUserInitiated == true ? true : state.canRefreshActivityFeed,
    );
  }

  if (action is SetIsRefreshingActivityFeed) {
    return state.copyWith(
      isRefreshingActivityFeed: action.isRefreshingActivityFeed,
    );
  }

  if (action is ReceiveMembers) {
    var members =
        _updateMembers(state.members, action.projectId, action.membersList);

    var selfMember = action.membersList.firstWhere(
        (item) => item.userId == state.user.userId,
        orElse: () => null);
    var favirouteTaskListIds = _updateFavirouteTaskListIds(
        state.favirouteTaskListIds, selfMember, action.projectId);

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
        inflatedProject: Optional.fromNullable(inflatedProject),
        favirouteTaskListIds: favirouteTaskListIds);
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
        listSorting: listSorting,
        inflatedProject: Optional.fromNullable(inflatedProject));
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

  if (action is SetLastUndoAction) {
    return state.copyWith(
        lastUndoAction: Optional.fromNullable(action.lastUndoAction),
        enableState: state.enableState.copyWith(
          canUndo: action.isInitializing != true &&
              action.lastUndoAction is NoAction == false,
          // On appInitialization, we don't let the user Trigger an Undo, even if there is a lastUndoAction available.
          // Otherwise, they could undo something they did from a previous session.
        ));
  }

  return state;
}

/*
  Helper Methods
*/

_filterTaskLists(
    String projectId, Map<String, List<TaskListModel>> taskListsByProject) {
  return taskListsByProject[projectId] ?? <TaskListModel>[];
}

_filterTasks(String projectId, Map<String, List<TaskModel>> tasksByProject) {
  return tasksByProject[projectId] ?? <TaskModel>[];
}

Optional<TaskModel> _updateSelectedTaskEntity(
    TaskModel originalEntity, List<TaskModel> tasks) {
  if (originalEntity == null) {
    // No need to update.
    return Optional.absent();
  }

  return Optional.fromNullable(tasks.firstWhere(
      (task) => task.uid == originalEntity.uid,
      orElse: () => null));
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

Map<String, TaskListModel> _updateDeletedTaskLists(
    Map<String, TaskListModel> existingMap,
    List<TaskListModel> incomingDeletedTasks,
    String originProjectId) {
  var newPrunedMap = Map<String, TaskListModel>.from(existingMap)
    ..removeWhere((key, value) => value.project == originProjectId);

  newPrunedMap
      .addEntries(incomingDeletedTasks.map((item) => MapEntry(item.uid, item)));

  return newPrunedMap;
}

List<TaskModel> _smooshAndMergeTasks(
    Map<String, List<TaskModel>> tasksByProject,
    List<TaskModel> newTasks,
    String originProjectId) {
  if (tasksByProject.isEmpty) {
    return newTasks.toList();
  }

  var list = <TaskModel>[];
  tasksByProject.forEach((key, value) {
    // If projectId matches originProjectId, use newTasks otherwise use the existing tasks.
    if (key == originProjectId) {
      list.addAll(newTasks);
    } else {
      list.addAll(tasksByProject[key]);
    }

    // list.addAll(key == originProjectId ? newTasks : tasksByProject[key]);
  });

  return list;
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

Map<String, TaskModel> _buildTasksById(List<TaskModel> allTasks) {
  return Map<String, TaskModel>.fromIterable(allTasks,
      key: (item) {
        var taskModel = item as TaskModel;
        return taskModel.uid;
      },
      value: (item) => item);
}

Map<String, List<MemberModel>> _updateMembers(
    Map<String, List<MemberModel>> existingMembersMap,
    String projectId,
    List<MemberModel> incomingMembersList) {
  var newMembersMap = Map<String, List<MemberModel>>.from(existingMembersMap);

  newMembersMap[projectId] = incomingMembersList;

  return newMembersMap;
}

Map<String, String> _updateFavirouteTaskListIds(
    Map<String, String> original, MemberModel selfMember, String projectId) {
  var newMap = Map<String, String>.from(original);

  if (selfMember == null || selfMember.favouriteTaskListId == '-1') {
    newMap.remove(projectId);
  } else {
    newMap[projectId] = selfMember.favouriteTaskListId;
  }

  return newMap;
}

// TODO: This is probably no longer requried. But needs proper testing after it's removed.
List<ActivityFeedEventModel> _filterActivityFeedEvents(
    List<ActivityFeedEventModel> original,
    Map<String, ProjectModel> projectsById) {
  return original.where((item) {
    if (projectsById.containsKey(item.projectId) == false) {
      return false;
    }

    return true;
  }).toList();
}
