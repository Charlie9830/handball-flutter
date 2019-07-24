import 'package:flutter/material.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/presentation/TaskListColorChit.dart';
import 'package:handball_flutter/utilities/Colors/AppThemeColors.dart';
import 'package:handball_flutter/utilities/getPositionFromGlobalKey.dart';

class TaskListSelectChip extends StatefulWidget {
  final List<TaskListModel> taskLists;
  final TaskListModel selectedTaskList;
  Color backgroundColor;
  EdgeInsets padding;
  final onChanged;
  final onPressed;

  TaskListSelectChip({
    this.taskLists,
    this.selectedTaskList,
    this.backgroundColor,
    this.padding,
    this.onChanged,
    this.onPressed,
  });

  @override
  _TaskListSelectChipState createState() => _TaskListSelectChipState();
}

class _TaskListSelectChipState extends State<TaskListSelectChip> {
  GlobalKey _actionChipKey = new GlobalKey();
  static const String _newList = 'NEW_LIST';

  @override
  Widget build(BuildContext context) {
    var isListSelected = widget.selectedTaskList != null;
    var text =
        isListSelected ? widget.selectedTaskList.taskListName : 'Choose list';

    return Padding(
      padding: widget.padding,
      child: GestureDetector(
        onTapDown: (details) => widget.onPressed(),
        child: ActionChip(
          key: _actionChipKey,
          backgroundColor: widget.backgroundColor,
          avatar: Icon(
            Icons.list,
            size: 18,
          ),
          label: Text(text),
          onPressed: () => _handlePressed(context),
        ),
      ),
    );
  }

  void _handlePressed(BuildContext context) async {
    var position = getPositionFromGlobalKey(_actionChipKey);

    var result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(0, position.top, position.right, 0),
      items: _getPopupMenuItems(widget.taskLists),
    );

    _submit(result);
  }

  void _submit(String result) {
    if (result == _newList) {
      widget.onChanged(TaskListSelectChipResult(
        taskListId: null,
        isNewList: true,
      ));
    } else {
      widget.onChanged(TaskListSelectChipResult(
        taskListId: result,
        isNewList: false,
      ));
    }
  }

  List<PopupMenuEntry> _getPopupMenuItems(List<TaskListModel> taskLists) {
    var sanitizedList = taskLists ?? <TaskListModel>[];

    var list = sanitizedList.map((taskList) {
      return PopupMenuItem(
          key: Key(taskList.uid),
          value: taskList.uid,
          child: ListTile(
            trailing: TaskListColorChit(color: taskList.customColor),
            title: Text(taskList.taskListName),
          ));
    }).toList();

    list.add(PopupMenuItem(
        key: Key('newList'),
        value: _newList,
        child: ListTile(
          leading: Icon(Icons.playlist_add),
          title: Text('New list'),
        )));

    return list;
  }  
}

class TaskListSelectChipResult {
  final String taskListId;
  bool isNewList;

  TaskListSelectChipResult({
    @required this.taskListId,
    @required this.isNewList,
  });
}
