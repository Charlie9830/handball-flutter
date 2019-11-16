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
      activityFeed: _extractActivityFeedList(
          store.state.activityFeed, store.state.selectedActivityFeedProjectId),
      selectedActivityFeedProjectId: store.state.selectedActivityFeedProjectId,
      projects: store.state.projects,
      isChangingActivityFeedLength:
          store.state.isChangingActivityFeedQueryLength,
      activityFeedQueryLength: store.state.activityFeedQueryLength,
      onActivityFeedQueryLengthSelect: (newValue) => store.dispatch(
          setActivityFeedQueryLengthAsync(
              store.state.activityFeedQueryLength, newValue)),
      onActivityFeedProjectSelect: (newValue) => store.dispatch(SetSelectedActivityFeedProjectId(projectId: newValue)) 
    );
  }

  List<ActivityFeedEventModel> _extractActivityFeedList(
      Map<String, List<ActivityFeedEventModel>> activityFeed,
      String selectedActivityFeedProjectId) {
    if (selectedActivityFeedProjectId == null ||
        selectedActivityFeedProjectId == '-1') {
      return activityFeed.values.expand((i) => i).toList();
    } else {
      return activityFeed[selectedActivityFeedProjectId] ??
          <ActivityFeedEventModel>[];
    }
  }
}
