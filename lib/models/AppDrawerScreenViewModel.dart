import 'package:handball_flutter/models/ProjectModel.dart';

class AppDrawerScreenViewModel {
  final List<ProjectViewModel> projectViewModels;
  final dynamic onAddNewProjectButtonPress;
  final dynamic onAppSettingsOpen;

  AppDrawerScreenViewModel({
    this.projectViewModels,
    this.onAddNewProjectButtonPress,
    this.onAppSettingsOpen,
    });
}