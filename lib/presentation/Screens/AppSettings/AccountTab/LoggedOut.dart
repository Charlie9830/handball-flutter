import 'package:flutter/material.dart';
import 'package:handball_flutter/utilities/isValidEmail.dart';

class LoggedOut extends StatefulWidget {
  final dynamic onSignIn;

  LoggedOut({
    this.onSignIn,
  });

  @override
  _LoggedOutState createState() => _LoggedOutState();
}

class _LoggedOutState extends State<LoggedOut> with TickerProviderStateMixin {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;
  String _emailErrorText;

  bool _isCompressed = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    _emailFocusNode.addListener(() {
      setState(() {
        _isCompressed = _emailFocusNode.hasFocus || _passwordFocusNode.hasFocus;

        if (_emailFocusNode.hasFocus == false) {
          _emailErrorText = _validateEmail(_emailController.text);
        }
      });
    });

    _passwordFocusNode.addListener(() => setState(() => _isCompressed =
        _emailFocusNode.hasFocus || _passwordFocusNode.hasFocus));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: TextField(
              focusNode: _emailFocusNode,
              controller: _emailController,
              onSubmitted: (_) => _handleEmailSubmit(context),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  hintText: 'Email Address', errorText: _emailErrorText),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: TextField(
              focusNode: _passwordFocusNode,
              controller: _passwordController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(hintText: 'Password'),
              obscureText: true,
            ),
          ),
          RaisedButton(
            child: Text('Sign In'),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
          Column(
            children: <Widget>[
              FlatButton(
                child: Text("Don't have an account? Sign Up"),
              ),
              FlatButton(
                child: Text("Forgot password?"),
              )
            ],
          ),
        ],
      ),
    );
  }

  String _validateEmail(String email) {
    return isValidEmail(email) ? null : 'Invalid email';
  }

  void _submit() {
    widget.onSignIn(LoginDetails(
        email: _emailController.text, password: _passwordController.text));
  }

  void _handleEmailSubmit(BuildContext context) {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  void _setEmailErrorText() {
    setState(() => _emailErrorText = _validateEmail(_emailController.text));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}

class LoginDetails {
  final String email;
  final String password;

  LoginDetails({
    this.email,
    this.password,
  });
}
