import 'package:flutter/material.dart';
import 'package:handball_flutter/models/TaskList.dart';

class MoveTasksBottomSheet extends StatefulWidget {
  final bool isMovingMultiple;
  final List<TaskListModel> taskListOptions;

  MoveTasksBottomSheet({Key key, this.isMovingMultiple, this.taskListOptions})
      : super(key: key);

  _MoveTasksBottomSheetState createState() => _MoveTasksBottomSheetState();
}

class _MoveTasksBottomSheetState extends State<MoveTasksBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Select List', style: Theme.of(context).textTheme.subhead),
            ),
            ListView(
              children: _getMainListChildren(),
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
            )
          ],
        );
      },
    );
  }

  List<Widget> _getMainListChildren() {
    return widget.taskListOptions.map((taskList) {
      return Container(
        key: Key(taskList.uid),
        child: ListTile(
          title: Text(taskList.taskListName),
          onTap: () => _submit(taskList.uid),
        ),
      );
    }).toList();
  }

  void _submit(String taskListId) {
    Navigator.of(context).pop(taskListId);
  }
}
