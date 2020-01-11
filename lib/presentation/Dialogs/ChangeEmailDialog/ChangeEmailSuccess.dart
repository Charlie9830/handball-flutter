import 'package:flutter/material.dart';

class ChangeEmailSuccess extends StatelessWidget {
  final String newEmail;
  final dynamic onFinishButtonPressed;
  const ChangeEmailSuccess({Key key, this.newEmail, this.onFinishButtonPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text('Email address updated',
              style: Theme.of(context).textTheme.headline),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text('You will need to sign in with your new address',),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Text(newEmail ?? ''),
        ),
        RaisedButton(child: Text('Sign In'), onPressed: onFinishButtonPressed)
      ],
    );
  }
}
