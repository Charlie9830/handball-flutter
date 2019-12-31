import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:handball_flutter/globals.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/redux/iosDidReceiveNotificationWhileForegrounded.dart';
import 'package:handball_flutter/utilities/Reminders/onSelectNotification.dart';
import 'package:redux/redux.dart';

void initializeLocalNotifications(Store<AppState> store) async {
  var initializationSettingsAndroid =
      new AndroidInitializationSettings('handball_notification_icon');

  var initializationSettingsIOS = new IOSInitializationSettings(
      onDidReceiveLocalNotification:
          iosOnDidReceiveLocalNotificationWhileForegrounded);

  var initializationSettings = new InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);

  await notificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) => onSelectNotification(payload, store));

  notificationsPlugin.cancelAll();
}
