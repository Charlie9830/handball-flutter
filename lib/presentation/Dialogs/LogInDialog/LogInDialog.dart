import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handball_flutter/models/EmailAndPassword.dart';
import 'package:handball_flutter/presentation/Dialogs/ForgotPasswordDialog/ForgotPasswordDialog.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/LoggedOut.dart';
import 'package:handball_flutter/presentation/SimpleAppBar.dart';
import 'package:handball_flutter/utilities/authExceptionHandlers.dart';
import 'package:handball_flutter/utilities/showSnackbar.dart';

class LogInDialog extends StatefulWidget {
  final FirebaseAuth auth;
  final bool hideSignUpButton;
  const LogInDialog({
    Key key,
    this.auth,
    this.hideSignUpButton,
  }) : super(key: key);

  @override
  _LogInDialogState createState() => _LogInDialogState();
}

class _LogInDialogState extends State<LogInDialog> {
  bool _isLoggingIn = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: SimpleAppBar(),
            body: PredicateBuilder(
              predicate: () => _isLoggingIn,
              maintainState: true,
              childIfTrue: Center(child: CircularProgressIndicator()),
              childIfFalse: Builder(
                builder: (innerContext) => LoggedOut(
                  onForgotPasswordButtonPressed: (currentEmail) =>
                      _handleForgotPassword(currentEmail, innerContext),
                  onSignIn: (email, password) =>
                      _handleSignIn(email, password, innerContext),
                  hideSignUpButton: widget.hideSignUpButton,
                ),
              ),
            )));
  }

  void _handleForgotPassword(String currentEmail, BuildContext context) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ForgotPasswordDialog(
            auth: widget.auth, initialValue: currentEmail));

    // Nothing to do here. Dialog takes care of everything.
  }

  void _handleSignIn(email, password, BuildContext context) async {
    setState(() {
      _isLoggingIn = true;
    });

    try {
      await widget.auth
          .signInWithEmailAndPassword(email: email, password: password);

      Navigator.of(context).pop(true);
    } on PlatformException catch (error) {
      setState(() {
        _isLoggingIn = false;
      });
      
      showSnackBar(message: getAuthExceptionFriendlyMessage(error), scaffoldState: Scaffold.of(context)); 
    }
  }
}
