import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';

class ActivityFeedDateRangeStatus extends StatelessWidget {
  final String text;
  final bool isRefreshing;
  final bool showProjectName;
  final String projectName;
  final bool showApplyButton;
  final dynamic onApplyButtonPressed;

  const ActivityFeedDateRangeStatus({
    this.text,
    this.isRefreshing,
    this.showProjectName,
    this.projectName,
    this.showApplyButton,
    this.onApplyButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PredicateBuilder(
      predicate: () => isRefreshing,
      childIfTrue: LinearProgressIndicator(),
      childIfFalse: PredicateBuilder(
        predicate: () => showApplyButton,
        childIfTrue: FlatButton(
          child: Text('Apply selected filters'),
          textColor: Theme.of(context).buttonTheme.colorScheme.secondary,
          onPressed: onApplyButtonPressed,
        ),
        childIfFalse: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(text, style: Theme.of(context).textTheme.caption),
              if (showProjectName)
                Text(' of', style: Theme.of(context).textTheme.caption),
              if (showProjectName)
                Text(' $projectName',
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold))
            ],
          ),
        ),
      ),
    );
  }
}
