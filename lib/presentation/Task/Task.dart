import 'package:flutter/material.dart';
import 'package:handball_flutter/models/Task.dart';

class Task extends StatelessWidget {
  Task({Key key, this.model});

  final TaskViewModel model;

  Widget build(BuildContext context) {
    return new Container(
      child: Row(
        children: <Widget>[
          Checkbox(value: model.data.isComplete, onChanged: model.onCheckboxChanged ),
          Expanded(
            child: Text(model.data.taskName),
            ),
        ],
      )
    );
  }
}

