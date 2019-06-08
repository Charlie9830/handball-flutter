import 'package:flutter/material.dart';

class Success extends StatelessWidget {
  final String message;
  final dynamic onStartButtonPressed;

  Success({
    this.message,
    this.onStartButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Icon(Icons.check_circle, size: 96, color: Colors.green),
        Text(message),
        RaisedButton(
          child: Text('Start'),
          color: Theme.of(context).primaryColor,
          onPressed: onStartButtonPressed,
        )
      ],
    ));
  }
}
