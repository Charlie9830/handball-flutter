import 'package:flutter/material.dart';
import 'package:handball_flutter/models/TaskList.dart';

class TaskListHeader extends StatelessWidget {
  final TaskListViewModel viewModel;

  TaskListHeader({Key key, this.viewModel});

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
          ),
          Expanded(
            child: Text(
              viewModel.data.taskListName,
              textAlign: TextAlign.center,
              )
          )
        ],
      ),
      color: Colors.deepOrange,
    );
  }
}