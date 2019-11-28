import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/AppDrawerScreenViewModel.dart';
import 'package:handball_flutter/models/ProjectInvite.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/presentation/Screens/AppDrawer/AppDrawer.dart';
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
      projectInviteViewModels: _buildProjectInviteViewModels(store, context),
      email: store.state.user.email,
      displayName: store.state.user.displayName,
      onAddNewProjectButtonPress: () =>
          store.dispatch(addNewProjectWithDialog(context)),
      onAppSettingsOpen: () => store.dispatch(OpenAppSettings()),
      onActivityFeedButtonPressed: () => store.dispatch(openActivityFeed('-1', ActivityFeedQueryLength.day)),
    );
  }

  List<ProjectInviteViewModel> _buildProjectInviteViewModels(
      Store<AppState> store, BuildContext context) {
    return store.state.projectInvites.map((item) {
      return ProjectInviteViewModel(
        data: item,
        isProcessing: store.state.processingProjectInviteIds.contains(item.projectId),
        onAccept: () => store.dispatch(acceptProjectInvite(item.projectId)),
        onDeny: () => store.dispatch(denyProjectInvite(item.projectId)),
      );
    }).toList();
  }

  List<ProjectViewModel> _buildProjectViewModels(
      Store<AppState> store, BuildContext context) {
    var sortedProjects = store.state.projects.toList()..sort( (a, b) => a.projectName.compareTo(b.projectName));

    return sortedProjects.map((item) {
      var indicatorGroup = store.state.projectIndicatorGroups[item.uid];

      return new ProjectViewModel(
          data: item,
          isSelected: item.uid == store.state.selectedProjectId,
          onSelect: () {
            store.dispatch(SelectProject(item.uid));
          },
          hasUnreadComments: indicatorGroup?.hasUnreadComments ?? false,
          laterDueDates:  indicatorGroup?.later ?? 0,
          soonDueDates: indicatorGroup?.soon ?? 0,
          todayDueDates: indicatorGroup?.today ?? 0,
          overdueDueDates: indicatorGroup?.overdue ?? 0,
          onDelete: () => store.dispatch(
              deleteProjectWithDialog(item.uid, item.projectName, context)),
          onShare: () =>
              store.dispatch(OpenShareProjectScreen(projectId: item.uid)));
    }).toList();
  }
}
