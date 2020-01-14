import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handball_flutter/models/EmailAndPassword.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/EmailAndPasswordInput.dart';
import 'package:handball_flutter/presentation/SimpleAppBar.dart';
import 'package:handball_flutter/utilities/showSnackbar.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(),
        body: Builder(
                  builder: (innerContext) => Container(
            padding: EdgeInsets.all(16),
            child: PredicateBuilder(
                predicate: () => _isAuthenticating,
                maintainState: true,
                childIfTrue: Center(child: CircularProgressIndicator()),
                childIfFalse: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Is that you?",
                        style: Theme.of(innerContext).textTheme.headline),
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
                          _handleAuthenticate(details, innerContext),
                      onHasFocusChange: (hasFocus) => setState(() {
                        _isCollapsed = hasFocus;
                      }),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }

  void _handleAuthenticate(
      EmailAndPassword loginDetails, BuildContext innerContext) async {
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
        Navigator.of(innerContext).pop(true);
      }
        
    } on PlatformException catch (e) {
      setState(() {
        _isAuthenticating = false;
      });
      _handleAuthenticationError(e, innerContext);
    }
  }

  void _handleAuthenticationError(PlatformException e, BuildContext innerContext) {
    switch (e.code) {
      case 'ERROR_WRONG_PASSWORD':
        showSnackBar(message: 'Incorrect password.', scaffoldState: Scaffold.of(innerContext));
        break;

      case 'ERROR_USER_NOT_FOUND':
        showSnackBar(message: 'Incorrect email address.', scaffoldState: Scaffold.of(innerContext));
        break;

      default:
        // TODO: This should point the user to a support email. It would be enraging if whilst trying to delete their account
        // they got a generic unhelpful error.
        showSnackBar(message: 'Sorry, something went wrong.', scaffoldState: Scaffold.of(innerContext));
        break;
    }
  }
}
