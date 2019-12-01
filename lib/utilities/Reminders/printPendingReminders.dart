import 'package:handball_flutter/globals.dart';

Future<void> printPendingNotifications() async {
  var pendingNotifications =
      await notificationsPlugin.pendingNotificationRequests();

  print('');
  print(' ========== PENDING NOTIFICATIONS ==========');
  for (var notification in pendingNotifications) {
    print(
        '${notification.id}    :    ${notification.body}     :     Payload ${notification.payload}');
  }
  print('==========    ============');
  print('');
}