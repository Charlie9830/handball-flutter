import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handball_flutter/globals.dart';
import 'package:handball_flutter/presentation/Dialogs/DeleteAccountDialog/DeleteAccountConfirmation.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/SimpleAppBar.dart';

class DeleteAccountDialog extends StatefulWidget {
  @override
  _DeleteAccountDialogState createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  bool _isAuthenticating = false;
  bool _authenticated = false;
  FirebaseAuth _auth;

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: SimpleAppBar(),
          body: Container(
            child: DeleteAccountConfirmation(
              onBackButtonPressed: () => _handleBackButtonPressed(context),
              onDeleteAccountButtonPressed: () =>
                  _handleDeleteAccountButtonPressed(context),
            ),
          )),
    );
  }

  void _handleBackButtonPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _handleDeleteAccountButtonPressed(BuildContext context) {
    Navigator.of(context).pop(deleteAccountConfirmationResult);
  }
}
