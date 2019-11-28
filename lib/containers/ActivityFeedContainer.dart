import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/models/ActivityFeedEventModel.dart';
import 'package:handball_flutter/models/ActivityFeedViewModel.dart';
import 'package:handball_flutter/presentation/Screens/ActivityFeed/ActivityFeed.dart';
import 'package:handball_flutter/redux/actions.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';

class ActivityFeedContainer extends StatelessWidget {
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, ActivityFeedViewModel>(
      converter: (Store<AppState> store) => _converter(store, context),
      builder: (context, viewModel) {
        return new ActivityFeed(
          viewModel: viewModel,
        );
      },
    );
  }

  _converter(Store<AppState> store, BuildContext context) {
    return new ActivityFeedViewModel(
      activityFeed: store.state.activityFeed,
      selectedActivityFeedProjectId: store.state.selectedActivityFeedProjectId,
      projects: store.state.projects,
      canRefreshActivityFeed: store.state.canRefreshActivityFeed,
      isRefreshingActivityFeed:
          store.state.isRefreshingActivityFeed,
      activityFeedQueryLength: store.state.activityFeedQueryLength,
      onActivityFeedProjectSelect: (newValue) => store.dispatch(SetSelectedActivityFeedProjectId(projectId: newValue, isUserInitiated: true)),
      onActivityFeedQueryLengthSelect: (newValue) => store.dispatch(SetActivityFeedQueryLength(length: newValue, isUserInitiated: true)),
      onApplyActivityFeedFilters: () => store.dispatch(refreshActivityFeed()),
      onClosing: () => store.dispatch(CloseActivityFeed()),
    );
  }
}
