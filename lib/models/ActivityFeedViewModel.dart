import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/ActivityFeedEventModel.dart';

class ActivityFeedViewModel {
  final List<ActivityFeedEventModel> activityFeed;
  final bool isChangingActivityFeedLength;
  final ActivityFeedQueryLength activityFeedQueryLength;
  final dynamic onActivityFeedQueryLengthSelect;
  
  ActivityFeedViewModel({
    this.activityFeed,
    this.isChangingActivityFeedLength,
    this.activityFeedQueryLength,
    this.onActivityFeedQueryLengthSelect,
  });
}