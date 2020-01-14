import 'package:handball_flutter/enums.dart';

class SplashScreenViewModel {
  final SplashScreenState splashScreenState;
  final dynamic onSignInButtonPressed;
  final dynamic onCreateAccountButtonPressed;

  SplashScreenViewModel({
    this.splashScreenState,
    this.onCreateAccountButtonPressed,
    this.onSignInButtonPressed,
  });
}
