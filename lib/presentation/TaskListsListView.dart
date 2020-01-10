import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:handball_flutter/InheritatedWidgets/EnableStates.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/presentation/HintButtons/AddTaskListHintButton.dart';
import 'package:handball_flutter/presentation/HomeScreenHintsMask.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/Task/Task.dart';
import 'package:handball_flutter/presentation/TaskList/TaskList.dart';
import 'package:handball_flutter/presentation/TaskList/TaskListHeader.dart';

class TaskListsListView extends StatelessWidget {
  final List<TaskListViewModel> taskListViewModels;
  final SlidableController taskSlidableController;
  final dynamic onAddNewTaskListButtonPressed;
  final dynamic onAddNewProjectButtonPressed;
  final dynamic onLogInButttonPress;

  TaskListsListView(
      {Key key,
      this.taskListViewModels,
      this.taskSlidableController,
      this.onAddNewTaskListButtonPressed,
      this.onAddNewProjectButtonPressed,
      this.onLogInButttonPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var showHintsMask = EnableStates.of(context).state.showHomeScreenMask;

    var taskLists = _buildTaskLists(context, taskListViewModels, taskSlidableController);

    var listView = ListView(
      shrinkWrap: showHintsMask == true,
      children: taskLists,
    );

    return PredicateBuilder(
        predicate: () => showHintsMask == true,
        childIfTrue: HomeScreenHintsMask(
          listView: listView,
          firstTaskListName: taskListViewModels.length > 0
              ? taskListViewModels.first?.data?.taskListName
              : null,
          onAddNewProjectButtonPressed: onAddNewProjectButtonPressed,
          onAddNewTaskListButtonPressed: onAddNewTaskListButtonPressed,
          onLogInButtonPress: onLogInButttonPress,
        ),
        childIfFalse: listView);
  }

  List<Widget> _buildTaskLists(
      BuildContext context, List<TaskListViewModel> viewModels, SlidableController tasksSlidableController) {
    List<Widget> widgets = viewModels.map((vm) {
      return Container(
        child: TaskList(
            uid: vm.data.uid,
            isFocused: vm.isFocused,
            onTap: vm.onTaskListFocus,
            header: TaskListHeader(
              name: vm.data.taskListName,
              isMenuDisabled: vm.isMenuDisabled,
              isChecklist: vm.data.settings.checklistSettings.isChecklist,
              onDelete: vm.onDelete,
              onRename: vm.onRename,
              onAddTaskButtonPressed: vm.onAddNewTaskButtonPressed,
              onSortingChange: vm.onSortingChange,
              sorting: vm.data.settings.sortBy,
              onOpenChecklistSettings: vm.onOpenChecklistSettings,
              onMoveToProject: vm.onMoveToProject,
              onChooseColor: vm.onChooseColor,
              customColor: vm.data.customColor,
              onFavouriteListChange: vm.onFaviourteListChange,
              isFaviroute: vm.isFaviroute,
            ),
            children: vm.childTaskViewModels.map((taskVm) {
              var showDivider = vm.childTaskViewModels.length != 1 && taskVm != vm.childTaskViewModels.last;
              return Task(
                key: Key(taskVm.data.uid),
                slidableController: tasksSlidableController,
                model: taskVm,
                isCompleting: taskVm.isCompleting,
                showDivider: showDivider ,);
            }).toList()),
      );
    }).toList();

    widgets.add(Container(
      child: AddListHintButton(onPressed: onAddNewTaskListButtonPressed),
    ));

    return widgets;
  }
}
