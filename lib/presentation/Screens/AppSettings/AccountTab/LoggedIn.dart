import 'package:flutter/material.dart';

class LoggedIn extends StatelessWidget {
  final String displayName;
  final String email;

  LoggedIn({
    this.displayName,
    this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 32),
      child: Column(
        children: <Widget>[
          Icon(Icons.person_outline,
          size: 40),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text('Signed In', style: Theme.of(context).textTheme.headline),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: <Widget>[
                Text(displayName),
                Text(email),
              ],
            )
          ),
          RaisedButton(
            child: Text('Sign Out'),
            onPressed: (){},
          ),

          Column(
            children: <Widget>[
              FlatButton(
                child: Text('Change password'),
              )
            ],
          )
        ],
      ),
    );
  }
}
