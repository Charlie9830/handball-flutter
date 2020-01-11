import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handball_flutter/presentation/Dialogs/ChangeEmailDialog/ChangeEmailSuccess.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/SimpleAppBar.dart';
import 'package:handball_flutter/utilities/CloudFunctionLayer.dart';
import 'package:handball_flutter/utilities/isValidEmail.dart';

class ChangeEmailDialog extends StatefulWidget {
  final CloudFunctionsLayer cloudFunctionsLayer;
  final FirebaseAuth auth;
  final String oldEmail;

  ChangeEmailDialog({
    @required this.cloudFunctionsLayer,
    @required this.auth,
    @required this.oldEmail,
  });

  @override
  _ChangeEmailDialogState createState() => _ChangeEmailDialogState();
}

class _ChangeEmailDialogState extends State<ChangeEmailDialog> {
  TextEditingController _controller;
  bool _isAwaitingRequest = false;
  bool _success = false;
  String _errorText;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            key: _scaffoldKey,
            appBar: SimpleAppBar(),
            body: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16),
              child: PredicateBuilder(
                predicate: () => _success == true,
                childIfTrue: ChangeEmailSuccess(
                    newEmail: _controller.text,
                    onFinishButtonPressed: () => Navigator.of(context).pop()),
                childIfFalse: PredicateBuilder(
                  predicate: () => _isAwaitingRequest,
                  maintainState: true,
                  childIfTrue: CircularProgressIndicator(),
                  childIfFalse: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text('Please enter a new email address below.'),
                      ),
                      TextField(
                        controller: _controller,
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        onSubmitted: (_) => _validateEmail(_controller.text),
                        decoration: InputDecoration(
                            hintText: 'Email address', errorText: _errorText),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: RaisedButton(
                          child: Text('Submit'),
                          onPressed: () => _handleSubmitButtonPressed(context),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }

  void _validateEmail(String email) {
    if (isValidEmail(email.trim())) {
      setState(() {
        _errorText = null;
      });
    } else {
      setState(() {
        _errorText = 'Invalid email.';
      });
    }
  }

  void _handleSubmitButtonPressed(BuildContext context) async {
    final newEmail = _controller.text.trim();
    final oldEmail = widget.oldEmail;

    if (newEmail == oldEmail) {
      _showSnackBar(
          context, 'You are already registered with that email address.');

      return;
    }

    if (isValidEmail(newEmail) == false) {
      setState(() {
        _errorText = 'Invalid email.';
      });
      return;
    }

    setState(() {
      _isAwaitingRequest = true;
      _errorText = null;
    });

    try {
      await widget.cloudFunctionsLayer.changeEmailAddress(
        newEmail: newEmail,
        oldEmail: oldEmail,
      );

      final user = await widget.auth.currentUser();
      user.reload();

      setState(() {
        _isAwaitingRequest = false;
        _success = true;
      });
    } on CloudFunctionsRejectionError catch (error) {
      setState(() {
        _isAwaitingRequest = false;
      });

      _showSnackBar(context, error.message);
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
