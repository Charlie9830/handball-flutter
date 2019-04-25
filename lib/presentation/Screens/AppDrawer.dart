import 'package:flutter/material.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/presentation/ProjectList.dart';

class AppDrawer extends StatelessWidget {
  final List<ProjectViewModel> projectViewModels;

  AppDrawer({this.projectViewModels});

  @override
  Widget build(BuildContext context) {
    new Scaffold(
            appBar: new AppBar(
              title: new Text(
                'Handball',
                style: Theme.of(context).textTheme.title,
              )
            ),
            body: ProjectList(projectViewModels: projectViewModels)
          );
  }
}