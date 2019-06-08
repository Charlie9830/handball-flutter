import 'package:flutter/material.dart';

class Success extends StatelessWidget {
  final String message;

  Success({
    this.message,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Icon(Icons.check_circle, size: 96, color: Colors.green),
        Text(message,
            style: Theme.of(context).textTheme.display1),
        RaisedButton(
          child: Text('Start'),
          color: Theme.of(context).primaryColor,
          onPressed: () {},
        )
      ],
    ));
  }
}
