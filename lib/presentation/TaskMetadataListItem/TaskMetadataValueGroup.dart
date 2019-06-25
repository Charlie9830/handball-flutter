import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskMetadataValueGroup extends StatelessWidget {
  final String title;
  final String by;
  final DateTime when;

  const TaskMetadataValueGroup({Key key, this.by, this.when, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8,0,8,16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(title ?? '', style: Theme.of(context).textTheme.subhead),
          Divider(),
          Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Row(
              children: <Widget>[
                Icon(Icons.person),
                SizedBox(width: 8),
                Expanded(child: Text(by ?? '')),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Icon(Icons.watch_later),
              SizedBox(width: 8),
              Expanded(child: Text(_processWhen(when)))
            ],
          )
        ],
      ),
    );
  }

  String _processWhen(DateTime when) {
    if (when == null) {
      return '';
    }

    var formattedDate = DateFormat('MMMMEEEEd').format(when);
    var formattedTime = DateFormat('jm').format(when);

    return '$formattedDate at $formattedTime';
  }
}
