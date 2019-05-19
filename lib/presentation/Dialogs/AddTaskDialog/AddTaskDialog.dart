import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/TextInputDialogModel.dart';
import 'package:handball_flutter/presentation/Dialogs/AddTaskDialog/DueDateShorcutChip.dart';
import 'package:handball_flutter/presentation/Dialogs/AddTaskDialog/PriorityShortcutChip.dart';
import 'package:handball_flutter/presentation/Dialogs/AddTaskDialog/TaskListSelectChip.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/redux/actions.dart';

class AddTaskDialog extends StatefulWidget {
  List<TaskListModel> taskLists;
  TaskListModel selectedTaskList;
  String text;

  AddTaskDialog({
    this.taskLists,
    this.selectedTaskList,
    this.text = '',
  });

  @override
  _AddTaskDialog createState() => _AddTaskDialog();
}

class _AddTaskDialog extends State<AddTaskDialog> {
  DateTime _dueDate;
  bool _isHighPriority = false;
  TextEditingController _controller;
  bool _isTaskListNew = false;
  TaskListModel _selectedTaskList;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
  }

  @override
  Widget build(BuildContext context) {
    var isListSelected = _selectedTaskList != null;

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: GestureDetector(
        onTap: () => _cancel(context),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 48,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              PredicateBuilder(
                                predicate: () =>
                                    widget.selectedTaskList == null,
                                childIfTrue: TaskListSelectChip(
                                  backgroundColor: isListSelected
                                      ? Theme.of(context)
                                          .chipTheme
                                          .backgroundColor
                                      : Theme.of(context).accentColor,
                                  selectedTaskList: _selectedTaskList ??
                                      widget.selectedTaskList,
                                  taskLists: _isTaskListNew == true
                                      ? (List.from(widget.taskLists)
                                        ..add(_selectedTaskList))
                                      : widget.taskLists,
                                  onChanged: (newValue) =>
                                      _handleTaskListSelectChanged(
                                          newValue, context),
                                ),
                                childIfFalse:
                                    SizedBox.fromSize(size: Size.zero),
                              ),
                              DueDateShortcutChip(
                                dueDate: _dueDate,
                                onChanged: (newDate) =>
                                    setState(() => _dueDate = newDate),
                              ),
                              PriorityShortcutChip(
                                  isHighPriority: _isHighPriority,
                                  onChanged: (newValue) => setState(
                                      () => _isHighPriority = newValue)),
                            ]),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              autofocus: true,
                              keyboardType: TextInputType.text,
                              maxLines: null,
                              keyboardAppearance: Theme.of(context).brightness,
                              onEditingComplete: () =>
                                  _submit(_controller.text, context),
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => _submit(_controller.text, context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTaskListSelectChanged(
      TaskListSelectChipResult result, BuildContext context) async {
    if (result.isNewList) {
      var dialogResult = await postTextInputDialog('List name', '', context);

      if (dialogResult.result == DialogResult.affirmative) {
        setState(() {
          _isTaskListNew = true;
          _selectedTaskList = TaskListModel(
            uid: 'new',
            project: null,
            taskListName: dialogResult.value,
          );
        });
      }
    } else {
      setState(() {
        _isTaskListNew = false;
        _selectedTaskList = widget.taskLists.firstWhere(
            (item) => item.uid == result.taskListId,
            orElse: () => null);
      });
    }
  }

  AddTaskDialogResult _constructResult(DialogResult result, {String taskName}) {
    return AddTaskDialogResult(
      result: result,
      isHighPriority: _isHighPriority,
      isNewTaskList: _isTaskListNew,
      selectedDueDate: _dueDate,
      taskListId: _selectedTaskList == null || _selectedTaskList.uid == 'new'
          ? null
          : _selectedTaskList.uid,
      taskListName: _selectedTaskList?.taskListName,
      taskName: taskName,
    );
  }

  bool isValid() {
    return _selectedTaskList != null;
  }

  void _submit(String taskName, BuildContext context) {
    Navigator.of(context).pop(_constructResult(DialogResult.affirmative, taskName: taskName));
  }

  void _cancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future<bool> _handleScopePop(BuildContext context) {
    _cancel(context);
    return Future.value(false);
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AddTaskDialogResult {
  DialogResult result;
  String taskName;
  bool isNewTaskList;
  String taskListId;
  String taskListName;
  DateTime selectedDueDate;
  bool isHighPriority;

  AddTaskDialogResult({
    this.result,
    this.taskName,
    this.isNewTaskList,
    this.taskListId,
    this.taskListName,
    this.isHighPriority,
    this.selectedDueDate,
  });
}
