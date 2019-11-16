import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/ActivityFeedEventModel.dart';
import 'package:handball_flutter/models/ActivityFeedViewModel.dart';
import 'package:handball_flutter/models/ProjectEventGroupModel.dart';
import 'package:handball_flutter/presentation/Nothing.dart';
import 'package:handball_flutter/presentation/Screens/ActivityFeed/ActivityFeedDateRangeStatus.dart';
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
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(16),
              child: GestureDetector(
                onTap: () => _handleActivityFeedLengthButtonPressed(context),
                child: Container(
                  alignment: Alignment.center,
                  color: Theme.of(context).bottomAppBarColor,
                  child: ActivityFeedDateRangeStatus(
                    isChangingQueryLength:
                        viewModel.isChangingActivityFeedLength,
                    text: _getRangeHintText(viewModel.activityFeedQueryLength),
                    showProjectName: viewModel.selectedActivityFeedProjectId != '-1',
                    projectName: _getSelectedProjectName(),
                  ),
                ),
              )),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.date_range),
              onPressed: () => _handleActivityFeedLengthButtonPressed(context),
            ),
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () => _handleFilterButtonPressed(context),
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                  itemCount: viewModel.activityFeed.length,
                  itemBuilder: (context, index) {
                    var event = projectEventsAndHeaders[index];

                    if (event is ProjectEventGroupModel) {
                      return Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          alignment: Alignment.center,
                          child: Text(
                              DateFormat('MMMMEEEEd').format(event.timestamp),
                              style:
                                  Theme.of(context).accentTextTheme.subtitle));
                    }

                    if (event is ActivityFeedEventModel) {
                      return ProjectEventListTile(
                        key: Key(event.uid),
                        projectName: event.projectName,
                        title: event.title,
                        details: event.details,
                        timestamp: event.timestamp,
                      );
                    }

                    return Nothing();
                  }),
            ),
          ],
        ));
  }

  String _getRangeHintText(ActivityFeedQueryLength queryLength) {
    switch (queryLength) {
      case ActivityFeedQueryLength.week:
        return 'Showing the last 7 days';

      case ActivityFeedQueryLength.twoWeek:
        return 'Showing the last 2 weeks';

      case ActivityFeedQueryLength.month:
        return 'Showing the last month';

      case ActivityFeedQueryLength.threeMonth:
        return 'Showing the last 3 months';

      case ActivityFeedQueryLength.sixMonth:
        return 'Showing the last 6 months';

      case ActivityFeedQueryLength.year:
        return 'Showing events up to 1 year ago';

      default:
        return '';
    }
  }

  String _getSelectedProjectName() {
    var project = viewModel.projects.firstWhere((item) => item.uid == viewModel.selectedActivityFeedProjectId, orElse: () => null);

    if (project == null) {
      return '';
    }

    return project.projectName;
  }

  void _handleFilterButtonPressed(BuildContext context) async {
    var result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text('Only show events from project'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text('Show All'),
                    textColor: Theme.of(context).colorScheme.secondaryVariant,
                    onPressed: () => Navigator.of(context).pop('-1'),
                  )
                ],
              ),
              Expanded(
                  child: ListView(
                children: viewModel.projects
                    .map((item) => ListTile(
                        key: Key(item.uid),
                        title: Text(item.projectName),
                        onTap: () => Navigator.of(context).pop(item.uid)))
                    .toList(),
              ))
            ],
          );
        });

    if (result == null || result.runtimeType != String) {
      return;
    }

    viewModel.onActivityFeedProjectSelect(result as String);
  }

  void _handleActivityFeedLengthButtonPressed(BuildContext context) async {
    var result = await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text('Show events dating back from'),
              ),
              ListView(
                shrinkWrap: true,
                children: <Widget>[
                  ListTile(
                    title: Text('Last 7 days'),
                    onTap: () =>
                        Navigator.of(context).pop(ActivityFeedQueryLength.week),
                  ),
                  ListTile(
                    title: Text('Last 2 weeks'),
                    onTap: () => Navigator.of(context)
                        .pop(ActivityFeedQueryLength.twoWeek),
                  ),
                  ListTile(
                    title: Text('Last 3 months'),
                    onTap: () => Navigator.of(context)
                        .pop(ActivityFeedQueryLength.threeMonth),
                  ),
                  ListTile(
                    title: Text('Last 6 months'),
                    onTap: () => Navigator.of(context)
                        .pop(ActivityFeedQueryLength.sixMonth),
                  ),
                  ListTile(
                    title: Text('Last year'),
                    onTap: () =>
                        Navigator.of(context).pop(ActivityFeedQueryLength.year),
                  ),
                ],
              ),
            ],
          );
        });

    if (result == null || result.runtimeType != ActivityFeedQueryLength) {
      return;
    }

    viewModel.onActivityFeedQueryLengthSelect(result);
  }

  List<dynamic> _getSortedAndGroupedProjectEvents() {
    // Group Events by the Day they occured on.
    var groupedEvents = groupBy(viewModel.activityFeed, (item) {
      var event = item as ActivityFeedEventModel;
      return event.daysSinceEpoch;
    });

    // The collection:groupBy functions used above leaves us with a Map. Keys being the days since epoch, values being Lists of
    // matching events. Sort the Keys so we will access the map in the correct order.
    var sortedKeys = groupedEvents.keys.toList()..sort((a, b) => b - a);
    List<dynamic> eventsAndHeaders = [];

    for (var key in sortedKeys) {
      eventsAndHeaders.add(ProjectEventGroupModel(key));
      eventsAndHeaders.addAll(groupedEvents[key]..sort(_projectEventComparer));
    }

    return eventsAndHeaders;
  }

  int _projectEventComparer(
      ActivityFeedEventModel a, ActivityFeedEventModel b) {
    return b.timestamp.second - a.timestamp.second;
  }
}
