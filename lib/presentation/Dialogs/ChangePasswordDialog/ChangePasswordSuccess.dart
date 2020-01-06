import 'package:flutter/material.dart';

class ChangePasswordSuccess extends StatelessWidget {
  final dynamic onFinishButtonPressed;
  const ChangePasswordSuccess({Key key, this.onFinishButtonPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text('Password updated', style: Theme.of(context).textTheme.headline),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Text('Keep it safe'),
        ),
        RaisedButton(
          child: Text('Finish'),
          onPressed: onFinishButtonPressed
        )
      ],
    );
  }
}
