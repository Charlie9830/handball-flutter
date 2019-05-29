import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/presentation/DueDateChit.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/ProjectListItem/ProjectIndicators.dart';

typedef OnSelectCallback = Function(String uid);

class ProjectListItem extends StatelessWidget {
  final ProjectViewModel viewModel;

  const ProjectListItem({
    Key key,
    this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      closeOnScroll: true,
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: ListTile(
          title: Text('${viewModel.projectName}',
              style: Theme.of(context).textTheme.body1),
          onTap: viewModel.onSelect,
          trailing: new ProjectIndicators(
            laterDueDates: viewModel.laterDueDates,
            soonDueDates: viewModel.soonDueDates,
            todayDueDates: viewModel.soonDueDates,
            overdueDueDates: viewModel.overdueDueDates,
            hasUnreadTaskComments: viewModel.hasUnreadComments,
          )),
      secondaryActions: <Widget>[
        IconSlideAction(
          icon: Icons.delete,
          caption: "Delete",
          color: Theme.of(context).colorScheme.error,
          onTap: viewModel.onDelete,
        )
      ],
    );
  }
}