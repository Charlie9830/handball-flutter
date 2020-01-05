import 'package:flutter/material.dart';

class PredicateBuilder extends StatelessWidget {
  final Widget childIfTrue;
  final Widget childIfFalse;
  final Function predicate;
  final bool maintainState;

  PredicateBuilder(
      {@required this.childIfTrue,
      @required this.childIfFalse,
      @required this.predicate,
      this.maintainState});

  @override
  Widget build(BuildContext context) {
    if (maintainState != null && maintainState == true) {
      final bool predicateResult = predicate();
      return Stack(
        children: <Widget>[
          Visibility(
            child: childIfTrue,
            maintainState: true,
            visible: predicateResult == true,
          ),
          Visibility(
            child: childIfFalse,
            maintainState: true,
            visible: predicateResult == false,
          )
        ],
      );
    }

    return predicate() ? childIfTrue : childIfFalse;
  }
}
