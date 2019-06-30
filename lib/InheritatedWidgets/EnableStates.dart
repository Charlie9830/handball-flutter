import 'package:flutter/material.dart';
import 'package:handball_flutter/models/EnableState.dart';

class EnableStates extends InheritedWidget {
  final EnableStateModel state;
  EnableStates({Key key, this.child, this.state}) : super(key: key, child: child);

  final Widget child;

  static EnableStates of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(EnableStates)as EnableStates);
  }

  @override
  bool updateShouldNotify( EnableStates oldWidget) {
    return oldWidget.state != state;
  }
}