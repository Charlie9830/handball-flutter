import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handball_flutter/models/EmailAndPassword.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/EmailAndPasswordInput.dart';
import 'package:handball_flutter/presentation/SimpleAppBar.dart';

class AccountReauthenticationDialog extends StatefulWidget {
  final FirebaseAuth auth;

  AccountReauthenticationDialog({
    @required this.auth,
  });

  @override
  _AccountReauthenticationDialogState createState() =>
      _AccountReauthenticationDialogState();
}

class _AccountReauthenticationDialogState
    extends State<AccountReauthenticationDialog> {
  bool _isCollapsed = false;
  bool _isAuthenticating = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: SimpleAppBar(),
        body: Container(
          padding: EdgeInsets.all(16),
          child: PredicateBuilder(
              predicate: () => _isAuthenticating,
              maintainState: true,
              childIfTrue: Center(child: CircularProgressIndicator()),
              childIfFalse: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Is that you?",
                      style: Theme.of(context).textTheme.headline),
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
                    buttonText: 'Authenticate',
                    onButtonPressed: (details) =>
                        _handleAuthenticate(details, context),
                    onHasFocusChange: (hasFocus) => setState(() {
                      _isCollapsed = hasFocus;
                    }),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  void _handleAuthenticate(
      EmailAndPassword loginDetails, BuildContext context) async {
    final email = loginDetails.email;
    final password = loginDetails.password;

    setState(() {
      _isAuthenticating = true;
    });

    final user = await widget.auth.currentUser();
    if (user == null) {
      // TODO: Handling here. User should never have been able to reach this. We can't throw a message saying they are logged out,
      // because that's confusing.
    }

    try {
      final authResult = await user.reauthenticateWithCredential(
          EmailAuthProvider.getCredential(email: email, password: password));
      if (authResult != null) {
        // Success.
        Navigator.of(context).pop(true);
      }
        
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
