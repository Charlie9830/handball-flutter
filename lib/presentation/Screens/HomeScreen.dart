import 'package:flutter/material.dart';
import 'package:handball_flutter/containers/AppDrawerContainer.dart';
import 'package:handball_flutter/models/HomeScreenViewModel.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/presentation/Dialogs/TextInputDialog.dart';
import 'package:handball_flutter/presentation/Task/Task.dart';
import 'package:handball_flutter/presentation/TaskList/TaskList.dart';
import 'package:handball_flutter/presentation/TaskList/TaskListHeader.dart';

class HomeScreen extends StatelessWidget {
  final HomeScreenViewModel viewModel;

  HomeScreen({this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(viewModel.projectName ?? ''),
        ),
        drawer: Drawer(
          child: AppDrawerContainer(),
        ),
        
        body: ListView(
            children: _buildTaskLists(context, viewModel.taskListViewModels)),
        floatingActionButton: FloatingActionButton(
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
}
