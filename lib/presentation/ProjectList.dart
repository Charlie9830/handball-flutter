import 'package:flutter/material.dart';
import 'package:handball_flutter/containers/models/ProjectModel.dart';
import 'package:handball_flutter/presentation/ProjectListItem.dart';

class ProjectList extends StatelessWidget {
  ProjectList({Key key,  this.projectViewModels});

  final List<ProjectViewModel> projectViewModels;

  Widget build(BuildContext context) {
    return new ListView(
      children: _getProjectListItems(projectViewModels)
    );
  }

  List<Widget> _getProjectListItems(List<ProjectViewModel> viewModels) {
    return viewModels.map( (item)  {
      return new ProjectListItem(viewModel: item);
    }).toList();
       
  }
}

