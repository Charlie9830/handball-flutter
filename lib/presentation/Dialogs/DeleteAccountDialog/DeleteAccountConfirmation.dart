import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Dialogs/DeleteAccountDialog/DeleteAccountConfirmationText.dart';

class DeleteAccountConfirmation extends StatelessWidget {
  final dynamic onBackButtonPressed;
  final dynamic onDeleteAccountButtonPressed;

  const DeleteAccountConfirmation(
      {Key key, this.onBackButtonPressed, this.onDeleteAccountButtonPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                      child: DeleteAccountConfirmationText()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Go Back'),
                      onPressed: onBackButtonPressed,
                    ),
                    RaisedButton(
                      child: Text('Delete Account'),
                      color: Colors.redAccent,
                      onPressed: onDeleteAccountButtonPressed,
                    )
                  ],
                )
              ],
            )),
      ),
    );
  }
}
