import 'package:flutter/material.dart';
import 'package:handball_flutter/containers/ProjectScreenContainer.dart';
import 'package:handball_flutter/keys.dart';
import 'package:handball_flutter/presentation/Dialogs/TextInputDialog.dart';
import 'package:handball_flutter/redux/actions.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:redux/redux.dart';

void navigationMiddleware(
  Store<AppState> store,
  dynamic action,
  NextDispatcher next,
) {
  next(action);

  if (action is NavigateToProject) {
    navigatorKey.currentState.push(new MaterialPageRoute(builder: (context) {
      return new ProjectScreenContainer();
    }));
  }

  if (action is NavigateToAppDrawer) {
    navigatorKey.currentState.pop();
  }

  if (action is SetTextInputDialog) {
    if (action.dialog.isOpen) {
      // Dialog Requested.
      navigatorKey.currentState.push(new MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) {
        return 
        Dialog(
          backgroundColor: Colors.transparent,
          child: TextInputDialog(
            isOpen: true,
            text: action.dialog.text,
            onOkay: action.dialog.onOkay,
      )
        );
        
      }));

    }

    else {
      navigatorKey.currentState.pop();
    }
    
  }
}
