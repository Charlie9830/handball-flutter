import 'package:flutter/material.dart';
import 'package:handball_flutter/models/ProjectScreenViewModel.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/presentation/Dialogs/TextInputDialog.dart';
import 'package:handball_flutter/presentation/Task/Task.dart';
import 'package:handball_flutter/presentation/TaskList/TaskList.dart';
import 'package:handball_flutter/presentation/TaskList/TaskListHeader.dart';

class ProjectScreen extends StatelessWidget {
  final ProjectScreenViewModel viewModel;

  ProjectScreen({this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(viewModel.projectName),
        ),
        body: ListView(
          children: _buildTaskLists(context, viewModel.taskListViewModels)
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          FloatingActionButton(
            onPressed: () => viewModel.onAddNewTaskFabButtonPressed(),
            child: Icon(Icons.add),
          )
        ]));
  }

  List<Widget> _buildTaskLists(
      BuildContext context, List<TaskListViewModel> viewModels) {
    return viewModels.map((vm) {
      return TaskList(
          isFocused: vm.isFocused,
          onTap: vm.onTaskListFocus,
          header: TaskListHeader(
            name: vm.data.taskListName,
            isFocused: vm.isFocused,
          ),
          children: vm.childTaskViewModels.map((taskVm) => Task(key: Key(taskVm.data.uid), model: taskVm)).toList());
    }).toList();
  }
}
