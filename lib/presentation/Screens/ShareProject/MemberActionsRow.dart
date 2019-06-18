import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';

class MemberActionsRow extends StatelessWidget {
  final bool isProcessing;
  final dynamic onPromote;
  final dynamic onDemote;
  final dynamic onKick;

  MemberActionsRow(
      {this.isProcessing, this.onPromote, this.onDemote, this.onKick});

  @override
  Widget build(BuildContext context) {
    return PredicateBuilder(
      predicate: () => isProcessing,
      childIfTrue: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
        ],
      ),
      childIfFalse: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          OutlineButton(
            child: Text('Promote'),
            onPressed: onPromote,
          ),
          OutlineButton(
            child: Text('Demote'),
            onPressed: onDemote,
          ),
          OutlineButton(
            child: Text('Kick'),
            onPressed: onKick,
          )
        ],
      ),
    );
  }
}
