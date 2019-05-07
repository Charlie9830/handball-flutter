import 'package:flutter/material.dart';

class PredicateBuilder extends StatelessWidget {
  final Widget childIfTrue;
  final Widget childIfFalse;
  final Function predicate;

  PredicateBuilder({
    @required this.childIfTrue,
    @required this.childIfFalse,
    @required this.predicate,
  });

  @override
  Widget build(BuildContext context) {
    return predicate() ? childIfTrue : childIfFalse;
  }
}