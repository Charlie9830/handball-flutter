import 'package:flutter/material.dart';

class ForgotPasswordSuccess extends StatelessWidget {
  final String emailAddress;
  final dynamic onFinishButtonPressed;

  const ForgotPasswordSuccess(
      {Key key, this.emailAddress, this.onFinishButtonPressed})
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
        Text('A password reset email has been sent to',
            style: Theme.of(context).textTheme.subtitle),
        Text(emailAddress ?? '', style: Theme.of(context).textTheme.subtitle),
        Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: RaisedButton(
            child: Text('Finish'),
            onPressed: onFinishButtonPressed,
          ),
        )
      ],
    );
  }
}
