import 'package:flutter/material.dart';
import 'package:handball_flutter/containers/AppDrawerContainer.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/models/HomeScreenViewModel.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/presentation/Dialogs/TextInputDialog.dart';
import 'package:handball_flutter/presentation/Nothing.dart';
import 'package:handball_flutter/presentation/ProjectMenu.dart';
import 'package:handball_flutter/presentation/Screens/HomeScreen/MultiSelectTaskAppBar.dart';
import 'package:handball_flutter/presentation/Task/Task.dart';
import 'package:handball_flutter/presentation/TaskList/TaskList.dart';
import 'package:handball_flutter/presentation/TaskList/TaskListHeader.dart';

class HomeScreen extends StatelessWidget {
  final HomeScreenViewModel viewModel;

  HomeScreen({this.viewModel});

  @override
  Widget build(BuildContext context) {
    double preferredSizeHeight = viewModel.showOnlySelfTasks == true ? 56.0 + 48.0 : 56.0;

    return Scaffold(
      key: homeScreenScaffoldKey,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(preferredSizeHeight),
          child: AnimatedCrossFade(
            firstChild: _getStandardAppBar(context),
            secondChild: MultiSelectTaskAppBar(
              onCancel: viewModel.onCancelMultiSelectTaskMode,
              onMoveTasks: viewModel.onMoveTasksButtonPressed,
            ),
            crossFadeState: viewModel.isInMultiSelectTaskMode
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 250),
          )),
      drawer: Drawer(
        child: AppDrawerContainer(),
      ),
      body: ListView(
          children: _buildTaskLists(context, viewModel.taskListViewModels)),
      floatingActionButton: viewModel.isInMultiSelectTaskMode == true
          ? Nothing()
          : FloatingActionButton(
              onPressed: () => viewModel.onAddNewTaskFabButtonPressed(),
              child: Icon(Icons.add),
            ),
    );
  }

  List<Widget> _buildTaskLists(
      BuildContext context, List<TaskListViewModel> viewModels) {
    return viewModels.map((vm) {
      return TaskList(
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
          ),
          children: vm.childTaskViewModels
              .map((taskVm) => Task(key: Key(taskVm.data.uid), model: taskVm))
              .toList());
    }).toList();
  }

  Widget _getStandardAppBar(BuildContext context) {
    return AppBar(
      title: Text(viewModel.projectName ?? ''),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          onPressed: viewModel.onShareProjectButtonPressed,
        ),
        ProjectMenu(
          onSetListSorting: viewModel.onSetListSorting,
          listSorting: viewModel.listSorting,
          showOnlySelfTasks: viewModel.showOnlySelfTasks,
          onShowOnlySelfTasksChanged: viewModel.onShowOnlySelfTasksChanged,
          isProjectShared: viewModel.isProjectShared,
        )
      ],
      bottom: viewModel.showOnlySelfTasks == true ? PreferredSize(
        preferredSize: Size.fromHeight(48),
        child: Container(
          color: Theme.of(context).primaryColorLight,
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text("Showing only tasks assigned to you"),
              ),
              FlatButton(
                child: Text("Show All"),
                onPressed: () => viewModel.onShowOnlySelfTasksChanged(false),
              )
            ],
          )
        ),
      ) : null
    );
  }
}
