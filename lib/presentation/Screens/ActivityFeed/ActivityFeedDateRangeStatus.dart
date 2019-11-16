import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';

class ActivityFeedDateRangeStatus extends StatelessWidget {
  final String text;
  final bool isChangingQueryLength;
  final bool showProjectName;
  final String projectName;

  const ActivityFeedDateRangeStatus({
    this.text,
    this.isChangingQueryLength,
    this.showProjectName,
    this.projectName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: PredicateBuilder(
          predicate: () => isChangingQueryLength,
          childIfTrue: CircularProgressIndicator(),
          childIfFalse: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(text, style: Theme.of(context).textTheme.caption),
                if (showProjectName)
                Text(' of', style: Theme.of(context).textTheme.caption),
                if (showProjectName)
                Text(' $projectName', style: TextStyle(color: Theme.of(context).accentColor, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ));
  }
}
