import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/EmailAndPasswordInput.dart';

class AccountReauthentication extends StatefulWidget {
  final bool isAuthenticating;
  final dynamic onAuthenticateButtonPressed;

  AccountReauthentication({
    this.isAuthenticating,
    this.onAuthenticateButtonPressed,
  });

  @override
  _AccountReauthenticationState createState() =>
      _AccountReauthenticationState();
}

class _AccountReauthenticationState extends State<AccountReauthentication> {
  bool _isCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return PredicateBuilder(
        predicate: () => widget.isAuthenticating,
        childIfTrue: Center(child: CircularProgressIndicator()),
        childIfFalse: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Is that you?", style: Theme.of(context).textTheme.headline),
            AnimatedContainer(
              duration: Duration(milliseconds: 250),
              height: _isCollapsed ? 0 : 86,
              child: Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 16),
                child: Text(
                    "We need to authenticate that it's you. Please enter your login details below."),
              ),
            ),
            EmailAndPasswordInput(
              buttonColor: Theme.of(context).accentColor,
              buttonText: 'Authenticate',
              onButtonPressed: widget.onAuthenticateButtonPressed,
              onHasFocusChange: (hasFocus) => setState(() {
                _isCollapsed = hasFocus;
              }),
            ),
          ],
        ));
  }
}
