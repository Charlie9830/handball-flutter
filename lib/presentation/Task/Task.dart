import 'package:flutter/material.dart';
import 'package:handball_flutter/configValues.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:handball_flutter/presentation/DueDateChit.dart';
import 'package:handball_flutter/presentation/Nothing.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/Task/AssignmentIndicator.dart';
import 'package:handball_flutter/presentation/Task/PriorityIndicator.dart';
import 'package:handball_flutter/presentation/Task/TaskCheckbox.dart';
import 'package:handball_flutter/utilities/ParseDueDate.dart';

class Task extends StatelessWidget {
  final SlidableController slidableController;
  final bool showDivider;
  final bool isCompleting;
  Task(
      {Key key,
      this.model,
      this.isCompleting = false,
      this.showDivider = true,
      this.slidableController});

  final TaskViewModel model;

  Widget build(BuildContext context) {
    final ParsedDueDate parsedDueDate =
        parseDueDate(model.data.isComplete, isCompleting, model.data.dueDate);

    var showPriorityIndicator =
        model.isInMultiSelectMode == false && model.data.isHighPriority;

    return new Slidable(
      key: Key(model.data.uid),
      actionPane: SlidableBehindActionPane(),
      controller: slidableController ?? SlidableController(),
      actionExtentRatio: 0.0,
      enabled: model.isInMultiSelectMode == false,
      closeOnScroll: true,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        dismissThresholds: bothSidesDismissThresholds,
        onWillDismiss: _handleWillDismiss
      ),
      child: InkWell(
          onTap: model.onTap,
          onLongPress: model.onLongPress,
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  PriorityIndicator(
                    isHighPriority: showPriorityIndicator,
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            TaskCheckbox(
                              isComplete: model.data.isComplete,
                              onCheckboxChanged: model.onCheckboxChanged,
                              isSelected: model.isMultiSelected,
                              onRadioChanged: model.onRadioChanged,
                              isInMultiSelectTaskMode:
                                  model.isInMultiSelectMode,
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 12),
                                child: Text(model.data.taskName,
                                    style: TextStyle(fontFamily: 'Ubuntu')),
                              ),
                            ),
                            if (isCompleting == true ||
                                parsedDueDate.type != DueDateType.unset &&
                                    model.data.isComplete ==
                                        false) // Hold the Chit if task is Animating out (isCompleting).
                              DueDateChit(
                                color: parsedDueDate.type,
                                text: parsedDueDate.text,
                                size: DueDateChitSize.standard,
                              ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 12, right: 8, bottom: 0),
                          child: Row(
                            children: <Widget>[
                              if (model.data.ownReminder != null)
                                Icon(Icons.notifications,
                                    color: Theme.of(context).disabledColor),
                              if (model.hasNote)
                                Icon(Icons.note,
                                    color: Theme.of(context).disabledColor),
                              if (model.data.hasUnseenComments)
                                Icon(Icons.comment),
                              if (model.data.isAssigned || isCompleting)
                                Expanded(
                                    child: AssignmentIndicator(
                                  assignments: model.assignments,
                                ))
                            ],
                          ),
                        ),
                        if (showDivider == true)
                          Divider(
                            indent: showPriorityIndicator == true ? 8 : 16,
                            height: 1,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Move',
          color: Colors.blueAccent,
          icon: Icons.move_to_inbox,
          onTap: model.onMove,
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.redAccent,
          icon: Icons.delete,
          onTap: model.onDelete,
        )
      ],
    );
  }

  bool _handleWillDismiss(SlideActionType actionType) {
    switch (actionType) {
      case SlideActionType.primary:
        model.onMove();
        return false;
      case SlideActionType.secondary:
        model.onDelete();
        return false;
      default:
        return false;
    }
  }
}
