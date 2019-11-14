import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProjectEventListTile extends StatelessWidget {
  final String title;
  final String projectName;
  final String details;
  final DateTime timestamp;

  const ProjectEventListTile({
    Key key,
    this.title,
    this.projectName,
    this.details,
    this.timestamp
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(title),
            subtitle: Text(details),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(projectName, style: Theme.of(context).textTheme.caption),
                Text(timeago.format(timestamp), style: Theme.of(context).textTheme.caption)
              ],
            ),
          ),
          Divider(),
        ],
      )
    );
  }
}