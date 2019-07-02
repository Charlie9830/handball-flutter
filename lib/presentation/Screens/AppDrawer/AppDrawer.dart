import 'package:flutter/material.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/models/AppDrawerScreenViewModel.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/presentation/ProjectList.dart';
import 'package:handball_flutter/presentation/Screens/AppDrawer/AppDrawerHeader.dart';
import 'package:handball_flutter/presentation/Screens/AppDrawer/ProjectInviteList.dart';

class AppDrawer extends StatelessWidget {
  final AppDrawerScreenViewModel viewModel;

  AppDrawer({this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: appDrawerScaffoldKey,
      extendBody: true,
      body: new Container(
          color: Theme.of(context).colorScheme.surface,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                AppDrawerHeader(
                  email: viewModel.email,
                  displayName: viewModel.displayName,
                  onCreateProjectButtonPressed:
                      viewModel.onAddNewProjectButtonPress,
                  onSettingsButtonPressed: viewModel.onAppSettingsOpen,
                ),
                ProjectInviteList(
                  viewModels: viewModel.projectInviteViewModels,
                ),
                Expanded(
                    child: ProjectList(
                        projectViewModels: viewModel.projectViewModels))
              ],
            ),
          )),
    );
  }
}
