import 'package:handball_flutter/containers/models/ProjectModel.dart';

class AppState {
  final List<ProjectModel> projects;
  final String selectedProjectId;

  AppState({
    this.projects,
    this.selectedProjectId,
    });

  AppState copyWith({
    List<ProjectModel> projects,
    String selectedProjectId,
  }) {
    return AppState(
      projects: projects ?? this.projects,
      selectedProjectId: selectedProjectId ?? this.selectedProjectId,
    );
  }
}
