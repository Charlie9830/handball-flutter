import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:handball_flutter/FirestoreStreamsContainer.dart';

final FirestoreStreamsContainer firestoreStreams = FirestoreStreamsContainer();

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

final deleteAccountConfirmationResult = 'DELETE_ACCOUNT';