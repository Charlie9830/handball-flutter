import 'package:flutter/material.dart';

class DeleteAccountInProgressMask extends StatelessWidget {
  const DeleteAccountInProgressMask({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleScopePop,
      child: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Deleting Account'),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      )),
    );
  }

  Future<bool> _handleScopePop() {
    return Future.value(false);
  }
}
