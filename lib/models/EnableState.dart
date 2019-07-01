class EnableStateModel {
  final bool showSelectAProjectHint;
  final bool showNoProjectsHint;
  final bool showNoTaskListsHint;
  final bool showSingleListNoTasksHint;
  final bool canMoveTaskList;

  final bool isLoggedIn;
  final bool isProjectSelected;

  /*
    UPDATE copyWith Method Below.
  */

  EnableStateModel({
    this.isLoggedIn = false,
    this.isProjectSelected = false,
    this.showNoProjectsHint = false,
    this.showNoTaskListsHint = false,
    this.showSelectAProjectHint = false,
    this.showSingleListNoTasksHint = false,
    this.canMoveTaskList = false,
    
  });

  EnableStateModel copyWith({
    bool showSelectAProjectHint,
    bool showNoProjectsHint,
    bool showNoTaskListsHint,
    bool isLoggedIn,
    bool isProjectSelected,
    bool showSingleListNoTasksHint,
    bool canMoveTaskList,
  }) {
    return EnableStateModel(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isProjectSelected: isProjectSelected ?? this.isProjectSelected,
      showNoProjectsHint: showNoProjectsHint ?? this.showNoProjectsHint,
      showNoTaskListsHint: showNoTaskListsHint ?? this.showNoTaskListsHint,
      showSelectAProjectHint:
          showSelectAProjectHint ?? this.showSelectAProjectHint,
      showSingleListNoTasksHint:
          showSingleListNoTasksHint ?? this.showSingleListNoTasksHint,
      canMoveTaskList: canMoveTaskList ?? this.canMoveTaskList,
    );
  }

  bool get showHomeScreenMask {
    return showSelectAProjectHint ||
        showLogInHint ||
        isProjectSelected == false ||
        showNoTaskListsHint ||
        showSingleListNoTasksHint;
  }

  bool get showLogInHint {
    return isLoggedIn == false;
  }

  bool get isAddTaskFabEnabled {
    return isProjectSelected == true;
  }

  bool get isProjectMenuEnabled {
    return isProjectSelected == true;
  }
}
