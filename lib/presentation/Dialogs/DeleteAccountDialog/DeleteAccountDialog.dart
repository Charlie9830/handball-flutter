import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handball_flutter/globals.dart';
import 'package:handball_flutter/models/LogInDetails.dart';
import 'package:handball_flutter/presentation/Dialogs/DeleteAccountDialog/AccountReauthentication.dart';
import 'package:handball_flutter/presentation/Dialogs/DeleteAccountDialog/DeleteAccountConfirmation.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';

class DeleteAccountDialog extends StatefulWidget {
  @override
  _DeleteAccountDialogState createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  bool _isAuthenticating = false;
  bool _authenticated = false;
  FirebaseAuth _auth;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Delete Account'),
          ),
          body: Container(
            padding: EdgeInsets.all(16),
              child: PredicateBuilder(
            predicate: () => _authenticated,
            childIfFalse: AccountReauthentication(
              isAuthenticating: _isAuthenticating,
              onAuthenticateButtonPressed: (details) {
                  _handleAuthenticate(details, context);}
            ),
            childIfTrue: DeleteAccountConfirmation(
              onBackButtonPressed: () => _handleBackButtonPressed(context),
              onDeleteAccountButtonPressed: () =>
                  _handleDeleteAccountButtonPressed(context),
            ),
          ))),
    );
  }

  void _handleBackButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _handleDeleteAccountButtonPressed(BuildContext context) {
    Navigator.of(context).pop(deleteAccountConfirmationResult);
  }

  void _handleAuthenticate(
      LoginDetails loginDetails, BuildContext context) async {
    final email = loginDetails.email;
    final password = loginDetails.password;

    setState(() {
      _isAuthenticating = true;
    });

    final user = await _auth.currentUser();
    if (user == null) {
      // TODO: Handling here. User should never have been able to reach this. We can't throw a message saying they are logged out,
      // because that's confusing.
    }

    try {
      final authResult = await user.reauthenticateWithCredential(
          EmailAuthProvider.getCredential(email: email, password: password));

      setState(() {
        _isAuthenticating = false;
        _authenticated = authResult.user != null;
      });
    } on PlatformException catch (e) {
      setState(() {
        _isAuthenticating = false;
      });
      _handleAuthenticationError(e);
    }
  }

  void _handleAuthenticationError(PlatformException e) {
    switch (e.code) {
      case 'ERROR_WRONG_PASSWORD':
        _showErrorSnackBar('Incorrect password.');
        break;

      case 'ERROR_USER_NOT_FOUND':
        _showErrorSnackBar("Incorrect email.");
        break;

      default:
        // TODO: This should point the user to a support email. It would be enraging if whilst trying to delete their account
        // they got a generic unhelpful error.
        _showErrorSnackBar("Something wen't wrong.");
        break;
    }
  }

  void _showErrorSnackBar(String message) {
    if (_scaffoldKey?.currentState == null) {
      return;
    }

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
