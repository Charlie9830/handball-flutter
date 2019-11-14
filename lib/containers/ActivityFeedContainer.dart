import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/models/ActivityFeedEventModel.dart';
import 'package:handball_flutter/models/ActivityFeedViewModel.dart';
import 'package:handball_flutter/presentation/Screens/ActivityFeed/ActivityFeed.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';

class ActivityFeedContainer extends StatelessWidget {
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, ActivityFeedViewModel> (
      converter: (Store<AppState> store) => _converter(store, context),
      builder: ( context, viewModel) {
        return new ActivityFeed(
          viewModel: viewModel,
        );
      },
    );
  }

  _converter(Store<AppState> store, BuildContext context) {
    return new ActivityFeedViewModel(
      activityFeed: store.state.activityFeed.values.expand((i) => i).toList()..sort(_activityFeedEventComparator),
    );
  }

  int _activityFeedEventComparator(ActivityFeedEventModel a, ActivityFeedEventModel b) {
    return a.timestamp.millisecondsSinceEpoch - b.timestamp.millisecondsSinceEpoch;
  }
}
