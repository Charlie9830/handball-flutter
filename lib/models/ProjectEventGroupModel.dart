class ProjectEventGroupModel {
  DateTime timestamp;

  ProjectEventGroupModel(int daysSinceEpoch) {
    timestamp = DateTime.fromMicrosecondsSinceEpoch(0).add(Duration(days: daysSinceEpoch));
  }
}