import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:handball_flutter/presentation/DueDateChit.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
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
      child: Container(
          child: Row(
        children: <Widget>[
          Checkbox(
              value: model.data.isComplete, onChanged: model.onCheckboxChanged),
          Expanded(
            child: Text(model.data.taskName),
          ),
          PredicateBuilder(
            predicate: () => parsedDueDate.type != DueDateType.unset,
            childIfTrue: DueDateChit(
              color: parsedDueDate.type,
              text: parsedDueDate.text,
              size: DueDateChitSize.standard,
            ),
            childIfFalse: IconButton(
              icon: Icon(Icons.edit),
            )
          )
        ],
      )),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Move',
          color: Colors.blueAccent,
          icon: Icons.move_to_inbox,
          onTap: () {},
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
