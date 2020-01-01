Map<String, String> mergeLastUsedTaskList(
    Map<String, String> existingMap, String projectId, String taskListId) {
  final newMap = Map<String, String>.from(existingMap ?? <String, String>{});
  newMap[projectId] = taskListId;

  return newMap;
}
