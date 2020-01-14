import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handball_flutter/presentation/Dialogs/ChangePasswordDialog/ChangePasswordSuccess.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/SimpleAppBar.dart';
import 'package:handball_flutter/utilities/showSnackbar.dart';

class ChangePasswordDialog extends StatefulWidget {
  final FirebaseAuth auth;

  ChangePasswordDialog({
    @required this.auth,
  });

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  TextEditingController _controller;
  bool _isAwaitingRequest = false;
  bool _success = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
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
                  predicate: () => _success == true,
                  childIfTrue: ChangePasswordSuccess(
                      onFinishButtonPressed: () => Navigator.of(innerContext).pop()),
                  childIfFalse: PredicateBuilder(
                    predicate: () => _isAwaitingRequest,
                    maintainState: true,
                    childIfTrue: CircularProgressIndicator(),
                    childIfFalse: Column(
                      children: <Widget>[
                        TextField(
                          controller: _controller,
                          autofocus: true,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration:
                              InputDecoration(hintText: 'Enter a new Password'),
                        ),
                        RaisedButton(
                          child: Text('Submit'),
                          onPressed: () => _handleSubmitButtonPressed(innerContext),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }

  void _handleSubmitButtonPressed(BuildContext context) async {
    setState(() {
      _isAwaitingRequest = true;
    });

    final user = await widget.auth.currentUser();

    if (user == null) {
      showSnackBar(message: 'Uh oh, something went wrong.', scaffoldState: Scaffold.of(context));
    }

    try {
      await user.updatePassword(_controller.text);
      setState(() {
        _isAwaitingRequest = false;
        _success = true;
      });
    } on PlatformException catch (error) {
      setState(() {
        _isAwaitingRequest = false;
      });

      if (error.code == 'ERROR_WEAK_PASSWORD') {
        showSnackBar(message: 'Password strength is too weak. Try using a password with at least 6 characters.', scaffoldState: Scaffold.of(context));
      }

      if (error.code == 'ERROR_REQUIRES_RECENT_LOGIN') {
        showSnackBar(message: 'Please reauthenticate your account again.', scaffoldState: Scaffold.of(context));
      }

      throw error;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
