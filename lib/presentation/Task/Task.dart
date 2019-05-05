import 'package:flutter/material.dart';
import 'package:handball_flutter/models/Task.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Task extends StatelessWidget {
  Task({Key key, this.model});

  final TaskViewModel model;

  Widget build(BuildContext context) {
    return new Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: Container(
        child: Row(
          children: <Widget>[
            Checkbox(value: model.data.isComplete, onChanged: model.onCheckboxChanged ),
            Expanded(
              child: Text(model.data.taskName),
              ),
          ],
      )
    ),
    actions: <Widget> [
      IconSlideAction(
      caption: 'Move',
      color: Colors.blueAccent,
      icon: Icons.move_to_inbox,
      onTap: (){},
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

