import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/presentation/DueDateChit.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';

class ProjectIndicators extends StatelessWidget {
  final int laterDueDates;
  final int soonDueDates;
  final int todayDueDates;
  final int overdueDueDates;
  final bool hasUnreadTaskComments;

  const ProjectIndicators(
      {this.laterDueDates,
      this.soonDueDates,
      this.todayDueDates,
      this.overdueDueDates,
      this.hasUnreadTaskComments});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (laterDueDates > 0)
            DueDateChit(
              color: DueDateType.later,
              text: laterDueDates.toString(),
              size: DueDateChitSize.small,
              onTap: null,
            ),
          if (soonDueDates > 0)
            DueDateChit(
              color: DueDateType.soon,
              text: soonDueDates.toString(),
              size: DueDateChitSize.small,
              onTap: null,
            ),
          if (todayDueDates > 0)
            DueDateChit(
              color: DueDateType.today,
              text: todayDueDates.toString(),
              size: DueDateChitSize.small,
              onTap: null,
            ),
          if (overdueDueDates > 0)
            DueDateChit(
              color: DueDateType.overdue,
              text: overdueDueDates.toString(),
              size: DueDateChitSize.small,
              onTap: null,
            ),
          if (hasUnreadTaskComments == true)
            Icon(Icons.comment)
        ]);
  }
}
