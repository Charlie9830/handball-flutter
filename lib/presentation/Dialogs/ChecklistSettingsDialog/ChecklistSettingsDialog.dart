import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/DateSelectListTile.dart';
import 'package:handball_flutter/presentation/Dialogs/ChecklistSettingsDialog/RenewIntervalListTile.dart';
import 'package:intl/intl.dart';

class ChecklistSettingsDialog extends StatefulWidget {
  final bool isChecklist;
  final DateTime renewDate;
  final int renewInterval;

  ChecklistSettingsDialog({
    this.isChecklist,
    this.renewDate,
    this.renewInterval,
  });

  @override
  _ChecklistSettingsDialogState createState() =>
      _ChecklistSettingsDialogState();
}

class _ChecklistSettingsDialogState extends State<ChecklistSettingsDialog> {
  bool _isChecklist;
  DateTime _renewDate;
  int _renewInterval;
  bool _hasUserIntervened = false;

  @override
  void initState() {
    super.initState();

    _isChecklist = widget.isChecklist;
    _renewDate = widget.renewDate;
    _renewInterval = widget.renewInterval;
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
                    'Checklists allow you to set a date and interval in which completed tasks in this list will be automatically renewed.',
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Switch(
                        value: _getIsChecklist(),
                        onChanged: (value) => setState(() {
                              _isChecklist = value;
                              _hasUserIntervened = true;
                            })),
                    Text("Enable"),
                  ],
                ),
                FlatButton(
                  child: Text('Renew now'),
                  onPressed:
                      _getIsChecklist() ? () => _renewNow(context) : null,
                  textColor: Theme.of(context).accentColor,
                ),
              ],
            ),
            DateSelectListTile(
                enabled: _getIsChecklist(),
                isClearable: false,
                firstDate: DateTime.now().subtract(Duration(days: 360)),
                lastDate: DateTime.now().add(Duration(days: 360)),
                initialDate: _getRenewDate(),
                hintText: 'Pick first renew date',
                onChange: (value) => setState(() {
                      _renewDate = value ?? DateTime.now(); // Enforce a date.
                      _hasUserIntervened = true;
                    })),
            RenewIntervalListTile(
                enabled: _getIsChecklist(),
                value: _getRenewInterval(),
                onChange: (value) => setState(() {
                      _renewInterval = value;
                      _hasUserIntervened = true;
                    })),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(_getNextRenewDateText(),
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.caption),
            ),
          ],
        ),
      ),
    );
  }

  String _getNextRenewDateText() {
    if (_isChecklist == false || _renewDate == null || _renewInterval == null) {
      return '';
    }

    var nextRenewDate = _renewDate.add(Duration(days: _renewInterval));
    var formatter = new DateFormat('MMMMEEEEd');

    return 'After ${formatter.format(_renewDate)}, next renewal will occur on ${formatter.format(nextRenewDate)}';
  }

  void _submit(BuildContext context) {
    var result = _hasUserIntervened ? _constructResult() : null;

    Navigator.of(context).pop(result);
  }

  void _renewNow(BuildContext context) {
    Navigator.of(context).pop(ChecklistSettingsDialogResult(renewNow: true));
  }

  ChecklistSettingsDialogResult _constructResult() {
    return ChecklistSettingsDialogResult(
      renewDate: _getRenewDate(),
      isChecklist: _getIsChecklist(),
      renewInterval: _getRenewInterval(),
    );
  }

  DateTime _getRenewDate() {
    return _renewDate;
  }

  bool _getIsChecklist() {
    return _isChecklist;
  }

  int _getRenewInterval() {
    return _renewInterval;
  }
}

class ChecklistSettingsDialogResult {
  final bool renewNow;
  final bool isChecklist;
  final DateTime renewDate;
  final int renewInterval;

  ChecklistSettingsDialogResult(
      {this.isChecklist, this.renewDate, this.renewInterval, this.renewNow});
}
