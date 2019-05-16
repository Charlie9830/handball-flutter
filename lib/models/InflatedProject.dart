import 'package:handball_flutter/models/InflatedTaskList.dart';
import 'package:handball_flutter/models/ProjectModel.dart';

class InflatedProjectModel {
  ProjectModel data;
  List<InflatedTaskListModel> inflatedTaskLists;
  Map<String, int> taskIndices;

  InflatedProjectModel({
    this.data,
    this.inflatedTaskLists,
    this.taskIndices,
  });
}