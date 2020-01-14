import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

showSnackBar(
    {GlobalKey<ScaffoldState> targetGlobalKey,
    ScaffoldState scaffoldState,
    @required String message,
    int autoHideSeconds = 6,
    String actionLabel,
    dynamic onClosed}) async {
  if (targetGlobalKey?.currentState == null && scaffoldState == null) {
    throw ArgumentError(
        'If targetGlobalKey is null, then scaffoldState must not be. And vice versa.');
  }

  final currentState = targetGlobalKey?.currentState ?? scaffoldState;

  // Close any currently open Snackbars on currentState.
  currentState.hideCurrentSnackBar(reason: SnackBarClosedReason.hide);

  var duration =
      autoHideSeconds == 0 ? null : Duration(seconds: autoHideSeconds);
  var snackBarAction = actionLabel == null
      ? null
      : SnackBarAction(
          label: actionLabel,
          onPressed: () => currentState.hideCurrentSnackBar(
              reason: SnackBarClosedReason.action),
        );

  var featureController = currentState.showSnackBar(SnackBar(
    content: Text(message ?? ''),
    action: snackBarAction,
    duration: duration,
  ));

  if (onClosed != null) {
    var reason = await featureController.closed;
    onClosed(reason);
  }
}
