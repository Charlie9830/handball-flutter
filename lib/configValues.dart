import 'package:flutter_slidable/flutter_slidable.dart';

int taskCommentPreviewLimit = 5;
int taskCommentQueryLimit = 10;
int taskReminderMessageLength = 64;
String taskReminderTitle = "Handball Task Reminder";
const int activityFeedTitleTruncationCount = 32;
const Duration taskEntryExitAnimationDuration = const Duration(milliseconds: 250);
const Duration taskCheckboxCompleteAnimationDuration = const Duration(milliseconds: 350);
const bothSidesDismissThresholds = <SlideActionType, double> { SlideActionType.primary: 0.5, SlideActionType.secondary: 0.5 };
const rightSideDismissThresholds = <SlideActionType, double> { SlideActionType.secondary: 0.5 };
const leftSideDismissThresholds = <SlideActionType, double> { SlideActionType.primary: 0.5 };