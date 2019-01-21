import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:handball_flutter/containers/AppDrawerContainer.dart';
import 'package:redux/redux.dart';
import './redux/appStore.dart';
import './redux/appState.dart';

void main() {
  runApp(App(store: appStore));
}

class App extends StatelessWidget {
  App({this.store});
  final store;

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
        store: store,
        child: new MaterialApp(
          title: 'Handball',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: new Scaffold(
            appBar: new AppBar(
              title: new Text(
                'Handball',
                style: Theme.of(context).textTheme.title,
              )
            ),
            body: new AppDrawerContainer(),
          )
        )
        );
  }
}

