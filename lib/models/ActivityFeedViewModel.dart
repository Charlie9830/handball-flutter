import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/ActivityFeedEventModel.dart';
import 'package:handball_flutter/models/ProjectModel.dart';

class ActivityFeedViewModel {
  final List<ActivityFeedEventModel> activityFeed;
  final List<ProjectModel> projects;
  final String selectedActivityFeedProjectId;
  final bool isRefreshingActivityFeed;
  final bool canRefreshActivityFeed;
  final ActivityFeedQueryLength activityFeedQueryLength;
  final dynamic onActivityFeedQueryLengthSelect;
  final dynamic onActivityFeedProjectSelect;
  final dynamic onApplyActivityFeedFilters;
  final dynamic onClosing;
  
  ActivityFeedViewModel({
    this.activityFeed,
    this.projects,
    this.selectedActivityFeedProjectId,
    this.isRefreshingActivityFeed,
    this.canRefreshActivityFeed,
    this.activityFeedQueryLength,
    this.onActivityFeedQueryLengthSelect,
    this.onActivityFeedProjectSelect,
    this.onApplyActivityFeedFilters,
    this.onClosing,
  });
}