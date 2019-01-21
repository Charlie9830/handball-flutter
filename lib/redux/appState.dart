import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/models/User.dart';

class AppState {
  final List<ProjectModel> projects;
  final String selectedProjectId;
  final User user;

  AppState({
    this.projects,
    this.selectedProjectId,
    this.user
    });

  AppState copyWith({
    List<ProjectModel> projects,
    String selectedProjectId,
    User user,
  }) {
    return AppState(
      projects: projects ?? this.projects,
      selectedProjectId: selectedProjectId ?? this.selectedProjectId,
      user: user ?? this.user,
    );
  }
}
