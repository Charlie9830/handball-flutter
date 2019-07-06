import 'package:flutter/material.dart';

class NoStoreFallback extends StatelessWidget {
  const NoStoreFallback({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text('Uh oh..', style: Theme.of(context).textTheme.headline),
          Text("Sorry, we can't connect to the store right now. Please try again later.")
        ],
      )
    );
  }
}