import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/AccountProgess.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/LoggedIn.dart';
import 'package:handball_flutter/presentation/Screens/AppSettings/AccountTab/LoggedOut.dart';

class AccountTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: LoggedIn(
        email: 'charliewjhall@gmail.com',
        displayName: 'Charlie Hall'
      )
    );
  }
}