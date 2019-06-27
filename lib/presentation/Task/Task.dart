import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:handball_flutter/presentation/DueDateChit.dart';
import 'package:handball_flutter/presentation/Nothing.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/Task/PriorityIndicator.dart';
import 'package:handball_flutter/presentation/Task/TaskCheckbox.dart';
import 'package:handball_flutter/utilities/ParseDueDate.dart';

class Task extends StatelessWidget {
  Task({Key key, this.model});

  final TaskViewModel model;

  Widget build(BuildContext context) {
    final ParsedDueDate parsedDueDate =
        ParseDueDate(model.data.isComplete, model.data.dueDate);

    return new Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      enabled: model.isInMultiSelectMode == false,
      child: InkWell(
          onTap: model.onTap,
          onLongPress: model.onLongPress,
          child: Row(
        children: <Widget>[
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
                      isInMultiSelectTaskMode: model.isInMultiSelectMode,
                    ),
                    Expanded(
                      child: Text(model.data.taskName),
                    ),
                    PredicateBuilder(
                        predicate: () =>
                            parsedDueDate.type != DueDateType.unset,
                        childIfTrue: DueDateChit(
                          color: parsedDueDate.type,
                          text: parsedDueDate.text,
                          size: DueDateChitSize.standard,
                        ),
                        childIfFalse: Nothing())
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Row(
                    children: <Widget>[
                      if (model.hasNote)
                        Icon(Icons.note,
                            color: Theme.of(context).disabledColor),
                      if (model.data.hasUnseenComments) Icon(Icons.comment),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
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
}
