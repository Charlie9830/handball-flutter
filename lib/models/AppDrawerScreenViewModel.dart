import 'package:handball_flutter/models/ProjectModel.dart';

class AppDrawerScreenViewModel {
  final List<ProjectViewModel> projectViewModels;
  final dynamic onAddNewProjectButtonPress;

  AppDrawerScreenViewModel({
    this.projectViewModels,
    this.onAddNewProjectButtonPress,
    });
}