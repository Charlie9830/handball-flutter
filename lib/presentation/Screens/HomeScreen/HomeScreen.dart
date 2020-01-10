import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:handball_flutter/InheritatedWidgets/EnableStates.dart';
import 'package:handball_flutter/containers/AppDrawerContainer.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/models/HomeScreenViewModel.dart';
import 'package:handball_flutter/presentation/Nothing.dart';
import 'package:handball_flutter/presentation/ProjectMenu.dart';
import 'package:handball_flutter/presentation/Screens/HomeScreen/MultiSelectTaskAppBar.dart';
import 'package:handball_flutter/presentation/TaskListsListView.dart';

class HomeScreen extends StatefulWidget {
  final HomeScreenViewModel viewModel;

  HomeScreen({this.viewModel});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SlidableController _taskSlidableController;

  @override
  void initState() {
    super.initState();
    _taskSlidableController = SlidableController();
  }

  @override
  Widget build(BuildContext context) {
    double preferredSizeHeight =
        widget.viewModel.showOnlySelfTasks == true ? 56.0 + 48.0 : 56.0;

    return Scaffold(
      key: homeScreenScaffoldKey,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(preferredSizeHeight),
          child: AnimatedCrossFade(
            firstChild: _getStandardAppBar(context),
            secondChild: MultiSelectTaskAppBar(
              onCancel: widget.viewModel.onCancelMultiSelectTaskMode,
              onMoveTasks: widget.viewModel.onMoveTasksButtonPressed,
              onCompleteTasks: widget.viewModel.onMultiCompleteTasks,
              onDeleteTasks: widget.viewModel.onMultiDeleteTasks,
              onAssignTo: widget.viewModel.onMultiAssignTasks,
            ),
            crossFadeState: widget.viewModel.isInMultiSelectTaskMode
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 250),
          )),
      drawer: Drawer(
        child: AppDrawerContainer(),
      ),
      body: TaskListsListView(
        taskSlidableController: _taskSlidableController,
        taskListViewModels: widget.viewModel.taskListViewModels,
        onAddNewTaskListButtonPressed: widget.viewModel.onAddNewTaskListButtonPressed,
        onAddNewProjectButtonPressed: widget.viewModel.onAddNewProjectButtonPressed,
        onLogInButttonPress: widget.viewModel.onLogInHintButtonPress,
      ),
      floatingActionButton: widget.viewModel.isInMultiSelectTaskMode == true ||
              EnableStates.of(context).state.isAddTaskFabEnabled == false
          ? Nothing()
          : FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => widget.viewModel.onAddNewTaskFabButtonPressed(),
              child: Icon(Icons.add),
            ),
    );
  }

  Widget _getStandardAppBar(BuildContext context) {
    return AppBar(
        title: Text(widget.viewModel.projectName ?? '',
        style: TextStyle(
          fontFamily: 'Ubuntu'
        )),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.bug_report),
              onPressed: widget.viewModel.onDebugButtonPressed,
            ),
          if (EnableStates.of(context).state.isProjectMenuEnabled)
            IconButton(
              icon: Icon(Icons.share),
              onPressed: widget.viewModel.onShareProjectButtonPressed,
            ),
          if (EnableStates.of(context).state.isProjectMenuEnabled)
            ProjectMenu(
              onSetListSorting: widget.viewModel.onSetListSorting,
              listSorting: widget.viewModel.listSorting,
              showOnlySelfTasks: widget.viewModel.showOnlySelfTasks,
              onShowOnlySelfTasksChanged: widget.viewModel.onShowOnlySelfTasksChanged,
              isProjectShared: widget.viewModel.isProjectShared,
              showCompletedTasks: widget.viewModel.showCompletedTasks,
              onShowCompletedTasksChanged:
                  widget.viewModel.onShowCompletedTasksChanged,
              onRenameProject: widget.viewModel.onRenameProject,
              onUndoAction: widget.viewModel.onUndoAction,
              onArchiveProject: widget.viewModel.onArchiveProject,
              onActivityFeedOpen: widget.viewModel.onActivityFeedOpen,
            ),
            
        ],
        bottom: widget.viewModel.showOnlySelfTasks == true
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
                              widget.viewModel.onShowOnlySelfTasksChanged(false),
                        )
                      ],
                    )),
              )
            : null);
  }
}
