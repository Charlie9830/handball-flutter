import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/models/AppDrawerScreenViewModel.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/presentation/Screens/AppDrawer.dart';
import 'package:handball_flutter/redux/actions.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';

class AppDrawerContainer extends StatelessWidget {
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, AppDrawerScreenViewModel>(
      converter: (Store<AppState> store) => _converter(store, context),
      builder: (context, appDrawerScreenViewModel) {
        return new AppDrawer(viewModel: appDrawerScreenViewModel);
      },
    );
  }

  AppDrawerScreenViewModel _converter(
      Store<AppState> store, BuildContext context) {
    return new AppDrawerScreenViewModel(
      projectViewModels: _buildProjectViewModels(store, context),
      onAddNewProjectButtonPress: () =>
          store.dispatch(addNewProjectWithDialog(context)),
      onAppSettingsOpen: () => store.dispatch(OpenAppSettings()),
    );
  }

  List<ProjectViewModel> _buildProjectViewModels(
      Store<AppState> store, BuildContext context) {
    return store.state.projects.map((item) {
      var indicatorGroup = store.state.projectIndicatorGroups[item.uid];

      return new ProjectViewModel(
        projectName: item.projectName,
        onSelect: () {
          store.dispatch(SelectProject(item.uid));
          store.dispatch(NavigateToProject());
        },
        hasUnreadComments: indicatorGroup?.hasUnreadComments ?? false,
        laterDueDates: indicatorGroup?.later ?? 0,
        soonDueDates: indicatorGroup?.soon ?? 0,
        todayDueDates: indicatorGroup?.today ?? 0,
        overdueDueDates: indicatorGroup?.overdue ?? 0,
        onDelete: () => store.dispatch(
            deleteProjectWithDialog(item.uid, item.projectName, context)),
      );
    }).toList();
  }
}
