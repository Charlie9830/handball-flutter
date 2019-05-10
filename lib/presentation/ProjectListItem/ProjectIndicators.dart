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

  
  const ProjectIndicators({
    this.laterDueDates,
    this.soonDueDates,
    this.todayDueDates,
    this.overdueDueDates,
    this.hasUnreadTaskComments
  });


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      
      children: <Widget>[
      PredicateBuilder(
          predicate: () => laterDueDates > 0,
          childIfTrue: DueDateChit(
            color: DueDateType.later,
            text: laterDueDates.toString(),
            size: DueDateChitSize.small,
            onTap: null,
          ),
          childIfFalse: SizedBox(height: 0, width: 0)),

          PredicateBuilder(
          predicate: () => soonDueDates > 0,
          childIfTrue: DueDateChit(
            color: DueDateType.soon,
            text: soonDueDates.toString(),
            size: DueDateChitSize.small,
            onTap: null,
          ),
          childIfFalse: SizedBox(height: 0, width: 0)),
          
          PredicateBuilder(
          predicate: () => todayDueDates > 0,
          childIfTrue: DueDateChit(
            color: DueDateType.today,
            text: todayDueDates.toString(),
            size: DueDateChitSize.small,
            onTap: null,
          ),
          childIfFalse: SizedBox(height: 0, width: 0)),

          PredicateBuilder(
          predicate: () => overdueDueDates > 0,
          childIfTrue: DueDateChit(
            color: DueDateType.overdue,
            text: overdueDueDates.toString(),
            size: DueDateChitSize.small,
            onTap: null,
          ),
          childIfFalse: SizedBox(height: 0, width: 0)),
      
    ]);
  }
}