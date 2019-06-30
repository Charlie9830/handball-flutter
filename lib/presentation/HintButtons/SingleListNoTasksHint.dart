import 'package:flutter/material.dart';

class SingleListNoTasksHint extends StatelessWidget {
  final String taskListName;
  const SingleListNoTasksHint({Key key, this.taskListName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('No tasks'),
          SizedBox(height: 8.0),
          Text('Touch the Add button below to add a Task to $taskListName '),
        ],
      )
    );
  }
}