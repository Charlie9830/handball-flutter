import 'package:flutter/material.dart';

class Failure extends StatelessWidget {
  final String message;

  Failure({
    this.message
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(message),
        ],
      )
    );
  }
}