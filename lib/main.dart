import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/containers/AppDrawerContainer.dart';
import 'package:handball_flutter/containers/ProjectScreenContainer.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/presentation/Dialogs/TextInputDialog.dart';
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

class _AppState extends State<App> {
  final Store<AppState> store;
  _AppState({this.store});

  @override
  void initState() {
    print('Init State');
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
          store.dispatch(signInUser());
          store.dispatch(SelectProject('toe5Cd3KIJDAB4dWA5so'));
        });
  }
  
  @override
  Widget build(BuildContext context) {
    
    return new StoreProvider<AppState>(
        store: store,
        child: new MaterialApp(
          title: 'Handball',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.dark,
          ),
          navigatorKey: navigatorKey,
          home: AppDrawerContainer(),
        )
        );
  }

  // Route<dynamic> _generateRoute(RouteSettings settings) {
  //   switch (settings.name) {
  //     case 'home':
  //     return MaterialPageRoute(
  //       builder: (context) => AppDrawerContainer(),
  //     );
  //     break;

  //     case 'project':
  //     return MaterialPageRoute(
  //       builder: (context) => ProjectScreenContainer(),
  //     );

  //     case 'dialog':
  //     return MaterialPageRoute(
  //       builder: (context) => settings.arguments,
  //     );
  //     break;

  //     default:
  //     return null;
  //   }
  // }
}


