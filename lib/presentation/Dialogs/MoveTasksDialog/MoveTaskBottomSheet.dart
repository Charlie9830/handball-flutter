import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/TextInputDialogModel.dart';
import 'package:handball_flutter/presentation/Dialogs/TextInputDialog.dart';
import 'package:handball_flutter/presentation/TaskListColorChit.dart';

class MoveTasksBottomSheet extends StatefulWidget {
  final List<TaskListModel> taskListOptions;

  MoveTasksBottomSheet({Key key, this.taskListOptions}) : super(key: key);

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
              child: Text('Select a List',
                  style: Theme.of(context).textTheme.subhead),
            ),
            Expanded(
              child: ListView(
                children: _getChildren(),
                physics: AlwaysScrollableScrollPhysics(),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _getChildren() {
    var widgets = widget.taskListOptions.map((taskList) {
      return Container(
        key: Key(taskList.uid),
        child: ListTile(
          title: Text(taskList.taskListName),
          trailing: TaskListColorChit(
            color: taskList.customColor,
          ),
          onTap: () =>
              _submit(MoveTaskBottomSheetResult(taskListId: taskList.uid)),
        ),
      );
    }).toList();

    widgets.insert(
        0,
        Container(
            key: Key('new-task-list-option'),
            child: ListTile(
              leading: Icon(Icons.playlist_add),
              title: Text('New List'),
              onTap: _handleNewListOptionTap,
            )));
    widgets.insert(
      1,
      Container(
        key: Key('new-task-list-option-divider'),
        child: Divider(),
      )
    );

    return widgets;
  }

  void _handleNewListOptionTap() async {
    var dialogResult = await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => TextInputDialog(title: 'New List', text: ''));

    if (dialogResult != null &&
        dialogResult is TextInputDialogResult &&
        dialogResult.result == DialogResult.affirmative) {
      _submit(MoveTaskBottomSheetResult(
          isNewTaskList: true, taskListName: dialogResult.value));
    }
  }

  void _submit(MoveTaskBottomSheetResult result) {
    Navigator.of(context).pop(result);
  }
}

class MoveTaskBottomSheetResult {
  final String taskListId;
  final bool isNewTaskList;
  final String taskListName;

  MoveTaskBottomSheetResult(
      {this.taskListId, this.taskListName, this.isNewTaskList});
}
