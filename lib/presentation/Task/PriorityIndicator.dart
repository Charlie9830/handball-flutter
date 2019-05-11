import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';

class PriorityIndicator extends StatelessWidget {
  final bool isHighPriority;

  PriorityIndicator({
    this.isHighPriority = false,
  });

  @override
  Widget build(BuildContext context) {
    return PredicateBuilder(
        predicate: () => isHighPriority,
        childIfTrue:
          Center(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange,
                )
              ),
            )
          ),
        childIfFalse: SizedBox(height: 0, width: 0));
  }
}
