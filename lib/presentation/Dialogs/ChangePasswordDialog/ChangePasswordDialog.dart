import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handball_flutter/presentation/Dialogs/ChangePasswordDialog/ChangePasswordSuccess.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/SimpleAppBar.dart';

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
                childIfTrue: ChangePasswordSuccess(
                    onFinishButtonPressed: () => Navigator.of(context).pop()),
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
                        onPressed: () => _handleSubmitButtonPressed(context),
                      )
                    ],
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
      _showSnackBar(context, 'Uh oh, something went wrong.');
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
        _showSnackBar(context,
            'Password is too weak, try using a password with at least 6 characters.');
      }

      if (error.code == 'ERROR_REQUIRES_RECENT_LOGIN') {
        _showSnackBar(context, 'Oops, please authenticate your account again.');
      }

      throw error;
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
