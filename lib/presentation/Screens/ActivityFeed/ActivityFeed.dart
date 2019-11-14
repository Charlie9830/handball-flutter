import 'package:flutter/material.dart';
import 'package:handball_flutter/models/ActivityFeedEventModel.dart';
import 'package:handball_flutter/models/ActivityFeedViewModel.dart';
import 'package:handball_flutter/models/ProjectEventGroupModel.dart';
import 'package:handball_flutter/presentation/Nothing.dart';
import 'package:handball_flutter/presentation/Screens/ActivityFeed/ProjectEventListTile.dart';
import "package:collection/collection.dart";
import 'package:intl/intl.dart';

class ActivityFeed extends StatelessWidget {
  final ActivityFeedViewModel viewModel;

  const ActivityFeed({
    Key key,
    this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var projectEventsAndHeaders = _getSortedAndGroupedProjectEvents();

    return Scaffold(
        appBar: AppBar(
          title: Text('Activity Feed'),
        ),
        body: ListView.builder(
            itemCount: viewModel.activityFeed.length,
            itemBuilder: (context, index) {
              var event = projectEventsAndHeaders[index];

              if (event is ProjectEventGroupModel) {
                return Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    alignment: Alignment.center,
                    child: Text(DateFormat('MMMMEEEEd').format(event.timestamp),
                        style: Theme.of(context).textTheme.subtitle));
              }

              if (event is ActivityFeedEventModel) {
                return ProjectEventListTile(
                  key: Key(event.uid),
                  projectName: event.projectName,
                  title: event.description,
                  details: event.details,
                  timestamp: event.timestamp,
                );
              }

              return Nothing();
            }));
  }

  List<dynamic> _getSortedAndGroupedProjectEvents() {
    // Group Events by the Day they occured on.
    var groupedEvents = groupBy(viewModel.activityFeed, (item) {
      var event = item as ActivityFeedEventModel;
      return event.daysSinceEpoch;
    });

    // The collection:groupBy functions used above leaves us with a Map. Keys being the days since epoch, values being Lists of
    // matching events. Sort the Keys so we will access the map in the correct order.
    var sortedKeys = groupedEvents.keys.toList()..sort();
    List<dynamic> eventsAndHeaders = [];

    for (var key in sortedKeys) {
      eventsAndHeaders.add(ProjectEventGroupModel(key));
      eventsAndHeaders.addAll(groupedEvents[key]..sort(_projectEventComparer));
    }

    return eventsAndHeaders;
  }

  int _projectEventComparer(ActivityFeedEventModel a, ActivityFeedEventModel b) {
    return a.timestamp.second - b.timestamp.second;
  }
}
