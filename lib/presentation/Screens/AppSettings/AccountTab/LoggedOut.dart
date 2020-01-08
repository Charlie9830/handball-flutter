import 'package:flutter/material.dart';
import 'package:handball_flutter/models/EmailAndPassword.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/EmailAndPasswordInput.dart';
import 'package:handball_flutter/utilities/isValidEmail.dart';

class LoggedOut extends StatefulWidget {
  final dynamic onSignIn;
  final dynamic onSignUpButtonPressed;
  final dynamic onForgotPasswordButtonPressed;

  LoggedOut({
    this.onSignIn,
    this.onSignUpButtonPressed,
    this.onForgotPasswordButtonPressed,
  });

  @override
  _LoggedOutState createState() => _LoggedOutState();
}

class _LoggedOutState extends State<LoggedOut> with TickerProviderStateMixin {
  bool _isCompressed = false;
  String _currentEnteredEmail = ''; // Keep track of this so it can be passed to the ForgotPasswordDialog as an initial value.

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            32, 0, 32, MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AnimatedSize(
              duration: Duration(milliseconds: 250),
              alignment: Alignment.topCenter,
              vsync: this,
              child: Container(
                height: _isCompressed ? 0 : 120,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 16),
                      child: Icon(
                        Icons.lock,
                        size: 40,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 8),
                      child: Text('Sign In',
                          style: Theme.of(context).textTheme.headline),
                    ),
                  ],
                ),
              ),
            ),
            EmailAndPasswordInput(
              buttonText: 'Sign In',
              buttonColor: Theme.of(context).accentColor,
              onHasFocusChange: _handleInputFieldsFocusChange,
              onButtonPressed: _handleLogInButtonPressed,
              onEmailChanged: (email) => setState(() => _currentEnteredEmail = email),
            ),
            Column(
              children: <Widget>[
                FlatButton(
                  child: Text("Don't have an account? Sign Up"),
                  onPressed: widget.onSignUpButtonPressed,
                ),
                FlatButton(
                  child: Text("Forgot password?"),
                  onPressed: () => widget.onForgotPasswordButtonPressed(_currentEnteredEmail),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogInButtonPressed(EmailAndPassword loginDetails) {
    widget.onSignIn(loginDetails.email, loginDetails.password);
  }

  void _handleInputFieldsFocusChange(bool hasFocus) {
    setState(() {
      _isCompressed = hasFocus;
    });
  }
}
