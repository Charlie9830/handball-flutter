import 'package:flutter/material.dart';
import 'package:handball_flutter/containers/models/ProjectModel.dart';

typedef OnSelectCallback = Function(String uid);

class ProjectListItem extends StatelessWidget {
  final ProjectViewModel viewModel;

  const ProjectListItem({
    Key key,
    this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(
        '${viewModel.name }',
        style: Theme.of(context).textTheme.body1
        ),
      onTap: viewModel.onSelect, 
    );
  }
}