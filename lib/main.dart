import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/InheritatedWidgets/EnableStates.dart';
import 'package:handball_flutter/containers/HomeScreenContainer.dart';
import 'package:handball_flutter/containers/SplashScreenContainer.dart';
import 'package:handball_flutter/enums.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/models/AppTheme.dart';
import 'package:handball_flutter/models/TopLevelViewModel.dart';
import 'package:handball_flutter/presentation/Dialogs/DeleteAccountDialog/DeleteAccountConfirmation.dart';
import 'package:handball_flutter/presentation/PredicateBuilder.dart';
import 'package:handball_flutter/presentation/Screens/SplashScreen/SplashScreen.dart';
import 'package:handball_flutter/presentation/Screens/SplashScreen/TourScreen.dart/TourScreenBase.dart';
import 'package:handball_flutter/redux/asyncActions.dart';
import 'package:handball_flutter/utilities/buildAppThemeData.dart';
import 'package:handball_flutter/utilities/quickActionsLayer/quickActionsLayer.dart';
import 'package:redux/redux.dart';

import './redux/appState.dart';
import './redux/appStore.dart';

void main() {
  runApp(App(store: appStore));
}

class App extends StatefulWidget {
  final Store<AppState> store;
  App({this.store});

  _AppState createState() => _AppState(store: store);
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final Store<AppState> store;
  _AppState({this.store});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      store.dispatch(initializeApp());

      // var user = await FirebaseAuth.instance.currentUser();
      // var updateInfo = UserUpdateInfo();
      // updateInfo.displayName = 'User E';
      // await user.updateProfile(updateInfo);

      // print("User Info Updated");
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
        store: store,
        child: StoreConnector(
          converter: (Store<AppState> store) => TopLevelViewModel(
            data: store.state.accountConfig?.appTheme ?? AppThemeModel(),
            enableState: store.state.enableState,
            splashScreenState: store.state.splashScreenState,
          ),

          builder: (BuildContext context, TopLevelViewModel viewModel) {
            final themeDataTuple = buildAppThemeData(viewModel.data);

            return EnableStates(
              state: viewModel.enableState,
              child: MaterialApp(
                title: 'Handball',
                theme: themeDataTuple.light,
                darkTheme: themeDataTuple.dark,
                themeMode: _getThemeMode(viewModel.data.themeBrightness),
                navigatorKey: navigatorKey,
                home: PredicateBuilder(
                  predicate: () => viewModel.splashScreenState == SplashScreenState.home,
                  maintainState: true,
                  childIfTrue: HomeScreenContainer(),
                  childIfFalse: SplashScreenContainer(),
              ),
            ));
          },
        ));
  }

  ThemeMode _getThemeMode(ThemeBrightness themeBrightness) {
    switch(themeBrightness) {
      case ThemeBrightness.light:
        return ThemeMode.light;

      case ThemeBrightness.dark:
        return ThemeMode.dark;

      case ThemeBrightness.device:
        return ThemeMode.system;

      default:
        return ThemeMode.system;

    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        //QuickActionsLayer.firePendingQuickActionIfAny();
        store.dispatch(processChecklists(store.state.taskLists));
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        QuickActionsLayer.reAssertShortcuts();
        // TODO: Handle this case.
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
