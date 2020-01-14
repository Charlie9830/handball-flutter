import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/models/SplashScreenViewModel.dart';
import 'package:handball_flutter/presentation/Screens/SplashScreen/SplashScreen.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/redux/asyncActions.dart';
import 'package:redux/redux.dart';

class SplashScreenContainer extends StatelessWidget {
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, SplashScreenViewModel>(
      converter: (Store<AppState> store) => _converter(store, context),
      builder: (context, viewModel) {
        return SplashScreen(
          splashScreenState: viewModel.splashScreenState,
          onCreateAccountButtonPressed: viewModel.onCreateAccountButtonPressed,
          onSignInButtonPressed: viewModel.onSignInButtonPressed,
        );
      },
    );
  }

  _converter(Store<AppState> store, BuildContext context) {
    return new SplashScreenViewModel(
      splashScreenState: store.state.splashScreenState,
      onCreateAccountButtonPressed: (lowerContext) => store.dispatch(showSignUpDialog(lowerContext)),
      onSignInButtonPressed: (lowerContext) => store.dispatch(showLogInDialog(lowerContext)),
    );
  }
}
