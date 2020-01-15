import 'package:flutter/material.dart';

class Success extends StatelessWidget {
  final String message;
  final dynamic onStartButtonPressed;
  final dynamic onTourButtonPressed;

  Success({
    this.message,
    this.onStartButtonPressed,
    this.onTourButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Icon(Icons.check_circle, size: 96, color: Colors.green),
        Text(message ?? ''),
        Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Take a Tour'),
              color: Theme.of(context).primaryColor,
              onPressed: onTourButtonPressed,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: FlatButton(
                child: Text('Jump right in'),
                onPressed: onStartButtonPressed,
              ),
            )
          ],
        )
      ],
    ));
  }
}
