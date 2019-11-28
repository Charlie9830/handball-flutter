import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/utilities/getActivityFeedEventIcon.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeedEventListTile extends StatelessWidget {
  final String title;
  final String projectName;
  final String details;
  final DateTime timestamp;
  final ActivityFeedEventType type;
  final bool important;

  const ActivityFeedEventListTile({
    Key key,
    this.title,
    this.projectName,
    this.details,
    this.timestamp,
    this.type,
    this.important,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('jm');

    return Container(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(getActivityFeedEventIcon(type), color: important ? Theme.of(context).colorScheme.secondaryVariant : null),
              title: Text(title),

              subtitle: Text(details),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(projectName, style: Theme.of(context).textTheme.caption),
                  Text( dateFormat.format(timestamp),
                     style: Theme.of(context).textTheme.caption)
                ],
              ),
            ),
            Divider(),
          ],
        ));
  }
}
