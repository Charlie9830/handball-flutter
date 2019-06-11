import 'package:handball_flutter/models/ProjectModel.dart';

class AppDrawerScreenViewModel {
  final List<ProjectViewModel> projectViewModels;
  final String email;
  final String displayName;
  final dynamic onAddNewProjectButtonPress;
  final dynamic onAppSettingsOpen;

  AppDrawerScreenViewModel({
    this.projectViewModels,
    this.email = '',
    this.displayName = '',
    this.onAddNewProjectButtonPress,
    this.onAppSettingsOpen,
    });
}