import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/presentation/DateSelectListTile.dart';
import 'package:handball_flutter/presentation/Dialogs/ChecklistSettingsDialog/RenewIntervalListTile.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/GeneralTab/MaterialColorPicker.dart';
import 'package:intl/intl.dart';

class TaskListColorSelectDialog extends StatefulWidget {
  final int colorIndex;
  final bool hasCustomColor;
  final String taskListName;

  TaskListColorSelectDialog({
    this.colorIndex,
    this.hasCustomColor,
    this.taskListName,
  });

  @override
  _TaskListColorSelectDialogState createState() =>
      _TaskListColorSelectDialogState();
}

class _TaskListColorSelectDialogState extends State<TaskListColorSelectDialog> {
  int _selectedColorIndex = -1;
  @override
  void initState() {
    super.initState();

    if (widget.hasCustomColor) {
      _selectedColorIndex = widget.colorIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.canvas,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => _submit(context),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                          'Select a custom colour for ${widget.taskListName}. This colour will apply for all contributors.')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                FlatButton(
                    child: Text('Clear'),
                    onPressed: () => setState(() => _selectedColorIndex = -1))
              ]),
              MaterialColorPicker(
                type: MaterialColorPickerType.primary,
                selectedColorIndex: _selectedColorIndex,
                onColorPick: (type, newColorIndex) =>
                    setState(() => _selectedColorIndex = newColorIndex),
              )
            ]),
      ),
    );
  }

  _submit(BuildContext context) {
    Navigator.of(context).pop(_selectedColorIndex);
  }
}
