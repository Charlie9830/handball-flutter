
import 'package:handball_flutter/models/ProjectModel.dart';

ProjectModel extractProject(String projectId, List<ProjectModel> projects) {
  return projects.firstWhere((item) => item.uid == projectId,
      orElse: () => null);
}
