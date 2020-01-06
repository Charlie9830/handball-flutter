import 'package:flutter/material.dart';

class RequestSuccess extends StatelessWidget {
  final String newDisplayName;
  final dynamic onFinishButtonPressed;
  const RequestSuccess(
      {Key key, this.newDisplayName, this.onFinishButtonPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Icon(Icons.check_circle, size: 96, color: Colors.green),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text('Success', style: Theme.of(context).textTheme.headline),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Text('Nice to meet you $newDisplayName'),
        ),
        RaisedButton(
          child: Text('Finish'),
          onPressed: onFinishButtonPressed,
        )
      ],
    );
  }
}
