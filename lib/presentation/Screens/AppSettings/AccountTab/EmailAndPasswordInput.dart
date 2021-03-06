import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:handball_flutter/models/EmailAndPassword.dart';
import 'package:handball_flutter/utilities/isValidEmail.dart';

class EmailAndPasswordInput extends StatefulWidget {
  final String buttonText;
  final Color buttonColor;
  final dynamic onHasFocusChange;
  final dynamic onButtonPressed;
  final dynamic onEmailChanged;

  EmailAndPasswordInput({
    this.buttonText,
    this.buttonColor,
    this.onHasFocusChange,
    this.onButtonPressed,
    this.onEmailChanged,
  });

  @override
  _EmailAndPasswordInputState createState() => _EmailAndPasswordInputState();
}

class _EmailAndPasswordInputState extends State<EmailAndPasswordInput> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  FocusNode _emailFocusNode;
  FocusNode _passwordFocusNode;
  String _emailErrorText;

  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    _emailFocusNode.addListener(_handleTextFocusNodeChange);
    _passwordFocusNode.addListener(_handleTextFocusNodeChange);

    _emailController.addListener(() {
      if (widget.onEmailChanged != null) {
        // In some cases the parent needs to keep track of the email address, so that it can be sent to the Forgot Password
        // Dialog as an initial value.
        widget.onEmailChanged(_emailController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
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
          padding: const EdgeInsets.only(top: 8, bottom: 24),
          child: TextField(
            focusNode: _passwordFocusNode,
            controller: _passwordController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(hintText: 'Password'),
            obscureText: true,
          ),
        ),
        RaisedButton(
          child: Text(widget.buttonText ?? ''),
          onPressed: _handleButtonPress,
          color: widget.buttonColor,
        ),
        if (!kReleaseMode)
        OutlineButton(
          child: Text('User A'),
          color: Theme.of(context).accentColor,
          onPressed: () {
            _emailController.text = 'a@test.com';
            _passwordController.text = 'adingusshrew';
            _handleButtonPress();
          },
        )
      ],
    );
  }

  void _handleButtonPress() {
    // Notify parent if email is valid. Else ensure we are showing the invalid state.
    if (isValidEmail(_emailController.text)) {
      widget.onButtonPressed(EmailAndPassword(
          email: _emailController.text, password: _passwordController.text));
    } else {
      setState(() {
        _emailErrorText = _getEmailErrorTextIfAny(_emailController.text);
      });
    }
  }

  void _handleTextFocusNodeChange() {
    // Notify parent on if we have Keyboard focus on our fields or not. Parent uses this to animate its self.
    if (_emailFocusNode.hasFocus || _passwordFocusNode.hasFocus) {
      if (widget.onHasFocusChange != null) {
        widget.onHasFocusChange(true);
      }
    } else {
      if (widget.onHasFocusChange != null) {
        widget.onHasFocusChange(false);
      }
    }
  }

  void _handleEmailSubmit(BuildContext context) {
    // Swap keyboard Focus to Password input.
    FocusScope.of(context).requestFocus(_passwordFocusNode);

    // Validate email format.
    setState(() {
      _emailErrorText = _getEmailErrorTextIfAny(_emailController.text);
    });
  }

  String _getEmailErrorTextIfAny(String email) {
    return isValidEmail(email) ? null : 'Invalid email';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }
}
