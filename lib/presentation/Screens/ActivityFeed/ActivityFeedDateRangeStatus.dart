import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';

class ActivityFeedDateRangeStatus extends StatelessWidget {
  final String text;
  final bool isChangingQueryLength;

  const ActivityFeedDateRangeStatus({
    this.text,
    this.isChangingQueryLength,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: PredicateBuilder(
          predicate: () => isChangingQueryLength,
          childIfTrue: CircularProgressIndicator(

          ),
          childIfFalse: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(text,
                    style: Theme.of(context).textTheme.caption),
          ),
        ));
  }
}
