import 'package:flutter/material.dart';
import 'package:handball_flutter/presentation/Screens/SignUp/Failure.dart';
import 'package:handball_flutter/presentation/Screens/SignUp/SignUpProgressIndicator.dart';
import 'package:handball_flutter/presentation/Screens/SignUp/Sucess.dart';

enum SignUpResult { indeterminate, success, error }

class Result extends StatelessWidget {
  final SignUpResult result;
  final String message;
  final dynamic onBackButtonPressed;
  final dynamic onStartButtonPressed;
  final dynamic onTourButtonPressed;

  Result({
    this.result,
    this.message,
    this.onBackButtonPressed,
    this.onStartButtonPressed,
    this.onTourButtonPressed,
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
          onBackButtonPressed: onBackButtonPressed,
      );

      case SignUpResult.success:
        return Success(
          message: message,
          onStartButtonPressed: onStartButtonPressed,
          onTourButtonPressed: onTourButtonPressed,
        );

      default:
        return Text("Uh oh, something went wrong");
    }
  }
}