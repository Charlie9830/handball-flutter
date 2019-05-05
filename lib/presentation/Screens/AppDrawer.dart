import 'package:flutter/material.dart';
import 'package:handball_flutter/models/AppDrawerScreenViewModel.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/presentation/ProjectList.dart';

class AppDrawer extends StatelessWidget {
  final AppDrawerScreenViewModel viewModel;


  AppDrawer({
    this.viewModel
    });

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
            appBar: new AppBar(
              title: new Text(
                'Handball',
                style: Theme.of(context).textTheme.title,
              )
            ),
            floatingActionButton: FloatingActionButton.extended(
              icon: Icon(Icons.add),
              label: Text("New Project"),
              onPressed: viewModel.onAddNewProjectButtonPress,
              heroTag: 'mainFab'
            ),
            body: ProjectList(projectViewModels: viewModel.projectViewModels)
          );
  }
}