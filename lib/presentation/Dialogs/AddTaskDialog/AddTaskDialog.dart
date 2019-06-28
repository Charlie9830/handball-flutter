import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/Assignment.dart';
import 'package:handball_flutter/models/Member.dart';
import 'package:handball_flutter/models/TaskList.dart';
import 'package:handball_flutter/models/TextInputDialogModel.dart';
import 'package:handball_flutter/presentation/Dialogs/AddTaskDialog/AssignmentShortcutChip.dart';
import 'package:handball_flutter/presentation/Dialogs/AddTaskDialog/DueDateShorcutChip.dart';
import 'package:handball_flutter/presentation/Dialogs/AddTaskDialog/PriorityShortcutChip.dart';
import 'package:handball_flutter/presentation/Dialogs/AddTaskDialog/TaskListSelectChip.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/redux/actions.dart';

class AddTaskDialog extends StatefulWidget {
  List<TaskListModel> taskLists;
  TaskListModel preselectedTaskList;
  String text;
  List<Assignment> assignmentOptions;
  Map<String, MemberModel> memberLookup;
  bool isProjectShared;
  bool allowTaskListChange;

  AddTaskDialog({
    this.taskLists,
    this.preselectedTaskList,
    this.text = '',
    this.allowTaskListChange,
    this.assignmentOptions,
    this.isProjectShared,
    this.memberLookup
  });

  @override
  _AddTaskDialog createState() => _AddTaskDialog();
}

class _AddTaskDialog extends State<AddTaskDialog> {
  DateTime _dueDate;
  bool _isHighPriority = false;
  TextEditingController _controller;
  FocusNode _textInputFocusNode;
  bool _isTaskListNew = false;
  TaskListModel _selectedTaskList;
  List<Assignment> assignments;
  Map<String, Assignment> assignmentMap;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
    _textInputFocusNode = new FocusNode();

    assignments = <Assignment>[];
  }

  @override
  Widget build(BuildContext context) {
    var taskListSelectChipColor = _getTaskListSelectChipColor(context);

    return WillPopScope(
      onWillPop: () => _handleScopePop(context),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
            alignment: Alignment.bottomCenter,
            child: Material(
              type: MaterialType.canvas,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 48,
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: <Widget>[
                                  PredicateBuilder(
                                    predicate: () =>
                                        widget.allowTaskListChange == true ||
                                        widget.preselectedTaskList == null,
                                    childIfTrue: TaskListSelectChip(
                                      padding: const EdgeInsets.only(left: 4, right: 4),
                                      backgroundColor: taskListSelectChipColor,
                                      selectedTaskList: _selectedTaskList ??
                                          widget.preselectedTaskList,
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
                                    padding: const EdgeInsets.only(left: 4, right: 4),
                                    dueDate: _dueDate,
                                    onChanged: (newDate) =>
                                        _handleDueDateChanged(newDate, context),
                                  ),
                                  PriorityShortcutChip(
                                      padding: const EdgeInsets.only(left: 4, right: 4),
                                      isHighPriority: _isHighPriority,
                                      onChanged: (newValue) => setState(
                                          () => _isHighPriority = newValue)),
                                  if (widget.isProjectShared == true)
                                  AssignmentShortcutChip(
                                    assignmentOptions: widget.assignmentOptions,
                                    assignments: assignments,
                                    onChanged: (newValue) => _handleAssignmentsChange(newValue, context),
                                  )
                                ]),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: _controller,
                                  autofocus: true,
                                  focusNode: _textInputFocusNode,
                                  keyboardType: TextInputType.text,
                                  maxLines: null,
                                  keyboardAppearance:
                                      Theme.of(context).brightness,
                                  onEditingComplete: () =>
                                      _submit(_controller.text, context),
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: isValid()
                                    ? () => _submit(_controller.text, context)
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void _handleAssignmentsChange(List<String> assignmentIds, BuildContext context) {
    _reattachTextInputFocus(context);

    var newAssignments = assignmentIds.map( (userId) {
      return Assignment(
        userId: userId,
        displayName:  widget.memberLookup[userId]?.displayName ?? '',
      );
    }).toList();

    setState( () => assignments = newAssignments);
  }

  Future<bool> _handleScopePop(BuildContext context) {
    return Future.value(true);
  }

  void _handleDueDateChanged(DateTime newDate, BuildContext context) {
    _reattachTextInputFocus(context);
    setState(() => _dueDate = newDate);
  }

  void _handleTaskListSelectChanged(
      TaskListSelectChipResult result, BuildContext context) async {
    if (result.isNewList) {
      var dialogResult = await postTextInputDialog('List name', '', context);

      if (dialogResult.result == DialogResult.affirmative) {
        _reattachTextInputFocus(context);
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
      _reattachTextInputFocus(context);

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
      taskListId: _getTaskListIdResult(),
      taskListName: _selectedTaskList?.taskListName,
      taskName: taskName,
      assignedToIds: assignments.map( (item) => item.userId).toList(),
    );
  }

  String _getTaskListIdResult() {
    // Fallback through values until we find a suitable value.
    if (_isTaskListNew) {
      return null;
    }

    if (_selectedTaskList == null) {
      return widget.preselectedTaskList.uid;
    }

    else {
      return _selectedTaskList.uid;
    }
  }

  bool isValid() {
    return _selectedTaskList != null || widget.preselectedTaskList != null;
  }

  void _submit(String taskName, BuildContext context) {
    if (isValid() == false) {
      return;
    }

    Navigator.of(context)
        .pop(_constructResult(DialogResult.affirmative, taskName: taskName));
  }

  void _reattachTextInputFocus(BuildContext context) {
    FocusScope.of(context).requestFocus(_textInputFocusNode);
  }

  Color _getTaskListSelectChipColor(BuildContext context) {
    if (widget.preselectedTaskList == null && _selectedTaskList == null) {
      // Nothing selected yet. Draw users attention.
      return Theme.of(context).accentColor;
    }

    var defaultColor = Theme.of(context).chipTheme.backgroundColor;

    if (_selectedTaskList != null) {
      // User has made a selection. No need to draw their attention.
      return defaultColor;
    }

    if (widget.preselectedTaskList != null && widget.allowTaskListChange == true) {
      // Tasklist has been pre selected, but user can still make changes.
      return defaultColor;
    }

    return defaultColor;
  }

  @override
  dispose() {
    _controller.dispose();
    _textInputFocusNode.dispose();
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
  List<String> assignedToIds;
  bool isHighPriority;

  AddTaskDialogResult({
    this.result,
    this.taskName,
    this.isNewTaskList,
    this.taskListId,
    this.taskListName,
    this.isHighPriority,
    this.selectedDueDate,
    this.assignedToIds,
  });
}
