import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:handball_flutter/InheritatedWidgets/EnableStates.dart';
import 'package:handball_flutter/containers/AppDrawerContainer.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/models/HomeScreenViewModel.dart';
import 'package:handball_flutter/presentation/Nothing.dart';
import 'package:handball_flutter/presentation/ProjectMenu.dart';
import 'package:handball_flutter/presentation/Screens/HomeScreen/HomeScreenAppBar.dart';
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
  final double appBarsPreferredSize = 72;

    return Scaffold(
      key: homeScreenScaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(appBarsPreferredSize),
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
        ),
      ),
      drawer: Drawer(
        child: AppDrawerContainer(),
      ),
      body: TaskListsListView(
        taskSlidableController: _taskSlidableController,
        taskListViewModels: widget.viewModel.taskListViewModels,
        topPadding: widget.viewModel.showOnlySelfTasks ? 108 : 84,
        onAddNewTaskListButtonPressed:
            widget.viewModel.onAddNewTaskListButtonPressed,
        onAddNewProjectButtonPressed:
            widget.viewModel.onAddNewProjectButtonPressed,
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
    return HomeScreenAppBar(
      title: widget.viewModel.projectName,
      actions: <Widget>[
        // Debug Button
        if (false)
          IconButton(
            icon: Icon(Icons.bug_report),
            onPressed: widget.viewModel.onDebugButtonPressed,
          ),

        if (EnableStates.of(context).state.isProjectSelected)
          IconButton(
            icon: Icon(Icons.playlist_add),
            onPressed: widget.viewModel.onAddNewTaskListButtonPressed,
          ),

        // Share Button
        if (EnableStates.of(context).state.isProjectMenuEnabled)
          IconButton(
            icon: Icon(Icons.share),
            onPressed: widget.viewModel.onShareProjectButtonPressed,
          ),

        // Project Menu
        if (EnableStates.of(context).state.isProjectMenuEnabled)
          ProjectMenu(
            onSetListSorting: widget.viewModel.onSetListSorting,
            listSorting: widget.viewModel.listSorting,
            showOnlySelfTasks: widget.viewModel.showOnlySelfTasks,
            onShowOnlySelfTasksChanged:
                widget.viewModel.onShowOnlySelfTasksChanged,
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
      showBottom: widget.viewModel.showOnlySelfTasks == true,
      bottom: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          color: Theme.of(context).accentColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Showing only tasks assigned to you",
                  style: Theme.of(context).textTheme.caption.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary)),
              FlatButton(
                child: Text("Show All"),
                textColor: Theme.of(context).colorScheme.onSecondary,
                onPressed: () =>
                    widget.viewModel.onShowOnlySelfTasksChanged(false),
              )
            ],
          )),
    );
  }
  //   return PreferredSize(
  //     preferredSize: Size.fromHeight(56),
  //     child: ClipPath(
  //       clipper: AppBarClipper(),
  //       child: AppBar(
  //           title: Text(widget.viewModel.projectName ?? '',
  //               style: TextStyle(fontFamily: 'Ubuntu')),
  //           actions: <Widget>[
  //             // Debug Button
  //             if (true)
  //               IconButton(
  //                 icon: Icon(Icons.bug_report),
  //                 onPressed: widget.viewModel.onDebugButtonPressed,
  //               ),

  //             if (EnableStates.of(context).state.isProjectSelected)
  //               IconButton(
  //                 icon: Icon(Icons.playlist_add),
  //                 onPressed: widget.viewModel.onAddNewTaskListButtonPressed,
  //               ),

  //             // Share Button
  //             if (EnableStates.of(context).state.isProjectMenuEnabled)
  //               IconButton(
  //                 icon: Icon(Icons.share),
  //                 onPressed: widget.viewModel.onShareProjectButtonPressed,
  //               ),

  //             // Project Menu
  //             if (EnableStates.of(context).state.isProjectMenuEnabled)
  //               ProjectMenu(
  //                 onSetListSorting: widget.viewModel.onSetListSorting,
  //                 listSorting: widget.viewModel.listSorting,
  //                 showOnlySelfTasks: widget.viewModel.showOnlySelfTasks,
  //                 onShowOnlySelfTasksChanged:
  //                     widget.viewModel.onShowOnlySelfTasksChanged,
  //                 isProjectShared: widget.viewModel.isProjectShared,
  //                 showCompletedTasks: widget.viewModel.showCompletedTasks,
  //                 onShowCompletedTasksChanged:
  //                     widget.viewModel.onShowCompletedTasksChanged,
  //                 onRenameProject: widget.viewModel.onRenameProject,
  //                 onUndoAction: widget.viewModel.onUndoAction,
  //                 onArchiveProject: widget.viewModel.onArchiveProject,
  //                 onActivityFeedOpen: widget.viewModel.onActivityFeedOpen,
  //               ),
  //           ],
  //           bottom: widget.viewModel.showOnlySelfTasks == true
  //               ? PreferredSize(
  //                   preferredSize: Size.fromHeight(48),
  //                   child: Container(
  //                       color: Theme.of(context).primaryColorLight,
  //                       height: 48,
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: <Widget>[
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 8),
  //                             child: Text("Showing only tasks assigned to you"),
  //                           ),
  //                           FlatButton(
  //                             child: Text("Show All"),
  //                             onPressed: () => widget.viewModel
  //                                 .onShowOnlySelfTasksChanged(false),
  //                           )
  //                         ],
  //                       )),
  //                 )
  //               : null),
  //     ),
  //   );
  // }
}
