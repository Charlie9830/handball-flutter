import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/containers/AppDrawerContainer.dart';
import 'package:handball_flutter/containers/HomeScreenContainer.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/presentation/Dialogs/TextInputDialog.dart';
import 'package:handball_flutter/presentation/EditableTextInput.dart';
import 'package:handball_flutter/redux/actions.dart';
import 'package:redux/redux.dart';
import './redux/appStore.dart';
import './redux/appState.dart';

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
      // updateInfo.displayName = 'User A';
      // await user.updateProfile(updateInfo);

      // print("User Info Updated");
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
        store: store,
        child: new MaterialApp(
          title: 'Handball',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.orangeAccent,
            brightness: Brightness.light,
          ),
          navigatorKey: navigatorKey,
          home: HomeScreenContainer(),
        ));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch(state) {
      case AppLifecycleState.resumed:
        store.dispatch(processChecklists(store.state.taskLists));
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.suspending:
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
