import 'package:flutter/material.dart';
import 'package:handball_flutter/InheritatedWidgets/EnableStates.dart';
import 'package:handball_flutter/containers/AppDrawerContainer.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/models/HomeScreenViewModel.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/presentation/Dialogs/TextInputDialog.dart';
import 'package:handball_flutter/presentation/HintButtons/AddTaskListHintButton.dart';
import 'package:handball_flutter/presentation/HintButtons/NoTaskListsHintButton.dart';
import 'package:handball_flutter/presentation/Nothing.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/ProjectMenu.dart';
import 'package:handball_flutter/presentation/Screens/HomeScreen/MultiSelectTaskAppBar.dart';
import 'package:handball_flutter/presentation/Task/Task.dart';
import 'package:handball_flutter/presentation/TaskList/TaskList.dart';
import 'package:handball_flutter/presentation/TaskList/TaskListHeader.dart';
import 'package:handball_flutter/presentation/TaskListsListView.dart';

class HomeScreen extends StatelessWidget {
  final HomeScreenViewModel viewModel;

  HomeScreen({this.viewModel});

  @override
  Widget build(BuildContext context) {
    double preferredSizeHeight =
        viewModel.showOnlySelfTasks == true ? 56.0 + 48.0 : 56.0;

    return Scaffold(
      key: homeScreenScaffoldKey,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(preferredSizeHeight),
          child: AnimatedCrossFade(
            firstChild: _getStandardAppBar(context),
            secondChild: MultiSelectTaskAppBar(
              onCancel: viewModel.onCancelMultiSelectTaskMode,
              onMoveTasks: viewModel.onMoveTasksButtonPressed,
              onCompleteTasks: viewModel.onMultiCompleteTasks,
              onDeleteTasks: viewModel.onMultiDeleteTasks,
            ),
            crossFadeState: viewModel.isInMultiSelectTaskMode
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 250),
          )),
      drawer: Drawer(
        child: AppDrawerContainer(),
      ),
      body: TaskListsListView(
        taskListViewModels: viewModel.taskListViewModels,
        onAddNewTaskListButtonPressed: viewModel.onAddNewTaskListButtonPressed,
        onAddNewProjectButtonPressed: viewModel.onAddNewProjectButtonPressed,
        onLogInButttonPress: viewModel.onLogInHintButtonPress,
      ),
      floatingActionButton: viewModel.isInMultiSelectTaskMode == true ||
              EnableStates.of(context).state.isAddTaskFabEnabled == false
          ? Nothing()
          : FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => viewModel.onAddNewTaskFabButtonPressed(),
              child: Icon(Icons.add),
            ),
    );
  }

  Widget _getStandardAppBar(BuildContext context) {
    return AppBar(
        title: Text(viewModel.projectName ?? ''),
        actions: <Widget>[
          if (EnableStates.of(context).state.isProjectMenuEnabled)
            IconButton(
              icon: Icon(Icons.share),
              onPressed: viewModel.onShareProjectButtonPressed,
            ),
          if (EnableStates.of(context).state.isProjectMenuEnabled)
            ProjectMenu(
              onSetListSorting: viewModel.onSetListSorting,
              listSorting: viewModel.listSorting,
              showOnlySelfTasks: viewModel.showOnlySelfTasks,
              onShowOnlySelfTasksChanged: viewModel.onShowOnlySelfTasksChanged,
              isProjectShared: viewModel.isProjectShared,
              showCompletedTasks: viewModel.showCompletedTasks,
              onShowCompletedTasksChanged:
                  viewModel.onShowCompletedTasksChanged,
              onRenameProject: viewModel.onRenameProject,
              onUndoAction: viewModel.onUndoAction,
            )
        ],
        bottom: viewModel.showOnlySelfTasks == true
            ? PreferredSize(
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
                          onPressed: () =>
                              viewModel.onShowOnlySelfTasksChanged(false),
                        )
                      ],
                    )),
              )
            : null);
  }
}
