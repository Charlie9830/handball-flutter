import 'package:flutter/material.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/presentation/ProjectListItem/ProjectListItem.dart';
import 'package:handball_flutter/presentation/ReactiveAnimatedList.dart';

class ProjectList extends StatelessWidget {
  ProjectList({Key key,  this.projectViewModels});

  final List<ProjectViewModel> projectViewModels;

  Widget build(BuildContext context) {
    return new ReactiveAnimatedList(

      children: _getProjectListItems(projectViewModels)
    );
  }

  List<Widget> _getProjectListItems(List<ProjectViewModel> viewModels) {
    return viewModels.map( (item)  {
      return new ProjectListItem(
        key: Key(item.data.uid),
        viewModel: item);
    }).toList();
       
  }
}

