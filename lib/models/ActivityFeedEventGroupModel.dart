class ActivityFeedEventGroupModel {
  DateTime timestamp;

  ActivityFeedEventGroupModel(int daysSinceEpoch) {
    timestamp = DateTime.fromMicrosecondsSinceEpoch(0).add(Duration(days: daysSinceEpoch));
  }
}