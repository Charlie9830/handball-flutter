import 'package:flutter/material.dart';

class Failure extends StatelessWidget {
  final String message;
  final dynamic onBackButtonPressed;

  Failure({
    this.message,
    this.onBackButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(message),
          RaisedButton(
            child: Text('Go back'),
            onPressed: onBackButtonPressed,
          )
        ],
      )
    );
  }
}