import 'package:flutter/material.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/presentation/Screens/SplashScreen/Splash.dart';
import 'package:handball_flutter/presentation/Screens/SplashScreen/WelcomeScreen.dart/GetStartedPage.dart';
import 'package:handball_flutter/presentation/Screens/SplashScreen/WelcomeScreen.dart/WelcomeScreenBase.dart';

class SplashScreen extends StatelessWidget {
  final SplashScreenState splashScreenState;
  final dynamic onCreateAccountButtonPressed;
  final dynamic onSignInButtonPressed;

  const SplashScreen(
      {Key key,
      this.splashScreenState,
      this.onSignInButtonPressed,
      this.onCreateAccountButtonPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        child: AnimatedCrossFade(
          alignment: Alignment.center,
          duration: Duration(milliseconds: 350),
          crossFadeState: _getCrossFadeState(splashScreenState),
          firstChild: Splash(),
          secondChild:
              _getOnboardingOrLoggedOutChild(splashScreenState, context),
        ),
      ),
    );
  }

  Widget _getOnboardingOrLoggedOutChild(
      SplashScreenState splashScreenState, BuildContext context) {
    if (splashScreenState == SplashScreenState.onboarding) {
      return WelcomeScreenBase(
        onCreateAccountButtonPressed: () =>
            onCreateAccountButtonPressed(context),
        onSignInButtonPressed: () => onSignInButtonPressed(context),
      );
    }

    return GetStartedPage(
      onCreateAccountButtonPressed: () => onCreateAccountButtonPressed(context),
      onSignInButtonPressed: () => onSignInButtonPressed(context),
    );
  }

  CrossFadeState _getCrossFadeState(SplashScreenState splashScreenState) {
    if (splashScreenState == SplashScreenState.loading) {
      return CrossFadeState.showFirst;
    }

    if (splashScreenState == SplashScreenState.loggedOut ||
        splashScreenState == SplashScreenState.onboarding) {
      return CrossFadeState.showSecond;
    }

    return CrossFadeState.showFirst;
  }
}
