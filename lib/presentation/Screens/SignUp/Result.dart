import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Screens/SignUp/Failure.dart';
import 'package:handball_flutter/presentation/Screens/SignUp/SignUpProgressIndicator.dart';
import 'package:handball_flutter/presentation/Screens/SignUp/Sucess.dart';

enum SignUpResult { indeterminate, success, error }

class Result extends StatelessWidget {
  final SignUpResult result;
  final String message;

  Result({
    this.result,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getChild(),
    );
  }

  Widget _getChild() {
    switch (result) {
      case SignUpResult.indeterminate:
        return  SignUpProgressIndicator();

      case SignUpResult.error:
        return Failure(
          message: message,
      );

      case SignUpResult.success:
        return Success();

      default:
        return Text("Uh oh, something went wrong");
    }
  }
}