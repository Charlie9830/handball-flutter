import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:handball_flutter/configValues.dart';
import 'package:handball_flutter/models/ProjectModel.dart';
import 'package:handball_flutter/presentation/ProjectListItem/ProjectIndicators.dart';

typedef OnSelectCallback = Function(String uid);

class ProjectListItem extends StatelessWidget {
  final ProjectViewModel viewModel;
  final SlidableController slidableController;

  const ProjectListItem({
    Key key,
    this.viewModel,
    this.slidableController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(viewModel.data.uid),
      controller: slidableController ?? SlidableController(),
      actionPane: SlidableBehindActionPane(),
      dismissal: SlidableDismissal(
          child: SlidableDrawerDismissal(),
          dismissThresholds: rightSideDismissThresholds,
          onWillDismiss: _handleWillDismiss),
      closeOnScroll: true,
      actionExtentRatio: 0.25,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListTile(
            selected: viewModel.isSelected,
            title: Text('${viewModel.data.projectName}',
                style: TextStyle(fontFamily: 'Ubuntu')),
            onTap: viewModel.onSelect,
            trailing: new ProjectIndicators(
              laterDueDates: viewModel.laterDueDates,
              soonDueDates: viewModel.soonDueDates,
              todayDueDates: viewModel.soonDueDates,
              overdueDueDates: viewModel.overdueDueDates,
              hasUnreadTaskComments: viewModel.hasUnreadComments,
            )),
      ),
      actions: <Widget>[
        IconSlideAction(
          icon: Icons.share,
          caption: 'Share',
          color: Colors.blue,
          onTap: viewModel.onShare,
        )
      ],
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

  bool _handleWillDismiss(SlideActionType actionType) {
    switch (actionType) {
      case SlideActionType.primary:
        return false;
      case SlideActionType.secondary:
        viewModel.onDelete();
        return false;
      default:
        return false;
    }
  }
}
