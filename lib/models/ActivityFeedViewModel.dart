import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/ActivityFeedEventModel.dart';
import 'package:handball_flutter/models/ProjectModel.dart';

class ActivityFeedViewModel {
  final List<ActivityFeedEventModel> activityFeed;
  final List<ProjectModel> projects;
  final String selectedActivityFeedProjectId;
  final bool isChangingActivityFeedLength;
  final ActivityFeedQueryLength activityFeedQueryLength;
  final dynamic onActivityFeedQueryLengthSelect;
  final dynamic onActivityFeedProjectSelect;
  
  ActivityFeedViewModel({
    this.activityFeed,
    this.projects,
    this.selectedActivityFeedProjectId,
    this.isChangingActivityFeedLength,
    this.activityFeedQueryLength,
    this.onActivityFeedQueryLengthSelect,
    this.onActivityFeedProjectSelect,
  });
}