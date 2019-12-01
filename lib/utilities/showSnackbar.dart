import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

showSnackBar(
    {@required GlobalKey<ScaffoldState> targetGlobalKey,
    @required String message,
    int autoHideSeconds = 6,
    String actionLabel,
    dynamic onClosed}) async {
  if (targetGlobalKey?.currentState == null) {
    throw ArgumentError(
        'targetGlobalKey or targetGlobalKey.currentState must not be null');
  }

  // Close any currently open Snackbars on targetGlobalKey.
  targetGlobalKey.currentState
      .hideCurrentSnackBar(reason: SnackBarClosedReason.hide);

  var duration =
      autoHideSeconds == 0 ? null : Duration(seconds: autoHideSeconds);
  var snackBarAction = actionLabel == null
      ? null
      : SnackBarAction(
          label: actionLabel,
          onPressed: () => targetGlobalKey.currentState
              .hideCurrentSnackBar(reason: SnackBarClosedReason.action),
        );

  var featureController = targetGlobalKey.currentState.showSnackBar(SnackBar(
    content: Text(message ?? ''),
    action: snackBarAction,
    duration: duration,
  ));

  if (onClosed != null) {
    var reason = await featureController.closed;
    onClosed(reason);
  }
}