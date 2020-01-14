import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handball_flutter/presentation/Dialogs/ForgotPasswordDialog/ForgotPasswordSuccess.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/SimpleAppBar.dart';
import 'package:handball_flutter/utilities/isValidEmail.dart';
import 'package:handball_flutter/utilities/showSnackbar.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final FirebaseAuth auth;
  final String initialValue;

  ForgotPasswordDialog({
    this.auth,
    this.initialValue,
  });

  @override
  _ForgotPasswordDialogState createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  TextEditingController _controller;
  String _errorText;
  bool _isAwaitingResponse = false;
  bool _isSuccessfull = false;

  @override
  void initState() {
    _controller = TextEditingController(
        text: widget.initialValue != '' && widget.initialValue != null
            ? widget.initialValue
            : '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: SimpleAppBar(),
            body: Builder(
                          builder: (innerContext) => Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16),
                  child: PredicateBuilder(
                    predicate: () => _isSuccessfull,
                    childIfTrue: ForgotPasswordSuccess(
                        emailAddress: _controller.text,
                        onFinishButtonPressed: () => Navigator.of(innerContext).pop()),
                    childIfFalse: PredicateBuilder(
                      predicate: () => _isAwaitingResponse,
                      maintainState: true,
                      childIfTrue: CircularProgressIndicator(),
                      childIfFalse: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 32.0),
                            child: Text(
                                "Please enter your email address below to receive a Password reset email."),
                          ),
                          TextField(
                            controller: _controller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              errorText: _errorText,
                            ),
                            onSubmitted: (_) => _validateAndSetErrorText,
                          ),
                          RaisedButton(
                            child: Text('Submit'),
                            onPressed: () => _handleSubmitButtonPressed(innerContext),
                          )
                        ],
                      ),
                    ),
                  )),
            )));
  }

  void _handleSubmitButtonPressed(BuildContext innerContext) async {
    final email = _controller.text;

    if (!isValidEmail(email)) {
      _validateAndSetErrorText();
      return;
    }

    setState(() {
      _isAwaitingResponse = true;
    });

    try {
      await widget.auth.sendPasswordResetEmail(email: email);

      setState(() {
        _isAwaitingResponse = false;
        _isSuccessfull = true;
      });
    } on PlatformException catch (error) {
      setState(() {
        _isAwaitingResponse = false;
      });

      if (error.code == 'ERROR_USER_NOT_FOUND') {
        showSnackBar(message: 'Email address does not match any accounts.', scaffoldState: Scaffold.of(context));
      }

      if (error.code == 'ERROR_INVALID_EMAIL') {
        showSnackBar(message: 'Invalid email. Please check the address and try again.', scaffoldState: Scaffold.of(context));
      }
    }
  }

  void _validateAndSetErrorText() {
    final email = _controller.text;

    if (isValidEmail(email) && _errorText != null) {
      setState(() {
        _errorText = null;
      });
    } else {
      setState(() {
        _errorText = 'Invalid email';
      });
    }
  }
}
