import 'package:handball_flutter/models/ProjectInvite.dart';
import 'package:handball_flutter/models/ProjectModel.dart';

class AppDrawerScreenViewModel {
  final List<ProjectViewModel> projectViewModels;
  final List<ProjectInviteViewModel> projectInviteViewModels;
  final String email;
  final String displayName;
  final dynamic onAddNewProjectButtonPress;
  final dynamic onAppSettingsOpen;

  AppDrawerScreenViewModel({
    this.projectViewModels,
    this.projectInviteViewModels,
    this.email = '',
    this.displayName = '',
    this.onAddNewProjectButtonPress,
    this.onAppSettingsOpen,
    });
}