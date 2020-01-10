import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/presentation/ProjectListItem/ProjectListItem.dart';
import 'package:handball_flutter/presentation/ReactiveAnimatedList.dart';

class ProjectList extends StatefulWidget {
  ProjectList({Key key, this.projectViewModels});

  final List<ProjectViewModel> projectViewModels;

  @override
  _ProjectListState createState() => _ProjectListState();
}

class _ProjectListState extends State<ProjectList> {
  SlidableController _slidableController;

  @override
  void initState() {
    super.initState();
    _slidableController = SlidableController();
  }

  Widget build(BuildContext context) {
    return new ReactiveAnimatedList(
        children: _getProjectListItems(widget.projectViewModels, _slidableController));
  }

  List<Widget> _getProjectListItems(List<ProjectViewModel> viewModels, SlidableController _slidableController) {
    return viewModels.map((item) {
      return new ProjectListItem(key: Key(item.data.uid), viewModel: item, slidableController: _slidableController);
    }).toList();
  }
}
