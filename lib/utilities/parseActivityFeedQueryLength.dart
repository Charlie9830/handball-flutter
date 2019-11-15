import 'package:handball_flutter/enums.dart';

Duration parseActivityFeedQueryLength(ActivityFeedQueryLength queryLength) {
  switch(queryLength) {
    case ActivityFeedQueryLength.week:
      return Duration(days: 7);

    case ActivityFeedQueryLength.twoWeek:
      return Duration(days: 14);

    case ActivityFeedQueryLength.month:
      return Duration(days: 30); 

    case ActivityFeedQueryLength.threeMonth:
      return Duration(days: 90);

    case ActivityFeedQueryLength.sixMonth:
      return Duration(days: 183);

    case ActivityFeedQueryLength.year:
      return Duration(days: 365);

    default:
      return Duration(days: 7);
  }
}