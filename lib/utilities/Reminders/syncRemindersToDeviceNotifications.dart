import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handball_flutter/utilities/isSameTime.dart';
import 'package:meta/meta.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:handball_flutter/models/Reminder.dart';
import 'package:handball_flutter/models/Task.dart';

void syncRemindersToDeviceNotifications(
    FlutterLocalNotificationsPlugin plugin,
    List<DocumentChange> documentChanges,
    Map<String, TaskModel> existingTasksMap,
    String userId) async {
  var currentNotificationsMap = await _getPendingDeviceNotificationsMap(plugin);
  var changedReminders =
      _extractChangedReminders(documentChanges, existingTasksMap, userId);

  var requests = <Future<void>>[];

  // Removed
  for (var reminder in changedReminders.removed) {
    if (currentNotificationsMap.containsKey(reminder.notificationId)) {
      requests.add(plugin.cancel(reminder.notificationId));
    }
  }

  // Added
  for (var reminder in changedReminders.added) {
    if (currentNotificationsMap.containsKey(reminder.notificationId) == false &&
        reminder.time.isAfter(DateTime.now())) {
      requests.add(_scheduleNotification(plugin, reminder));
    } else if (_notificationNeedsUpdate(
        currentNotificationsMap[reminder.notificationId], reminder)) {
      requests.add(_updateNotification(plugin, reminder));
    }
  }

  // Modifed
  for (var reminder in changedReminders.modified) {
    if (reminder.time.isAfter(DateTime.now()))
      requests.add(_updateNotification(plugin, reminder));
  }

  try {
    await Future.wait(requests);
  } catch (error) {
    throw error;
  }
}

bool _notificationNeedsUpdate(PendingNotificationRequest pendingNotification,
    ReminderModel incomingReminder) {
  if (pendingNotification == null) {
    return false;
  }

  var pendingReminder = ReminderModel.fromJSON(pendingNotification.payload);

  return pendingReminder.message != incomingReminder.message ||
      pendingReminder.isSeen != incomingReminder.isSeen ||
      isSameTime(pendingReminder.time, incomingReminder.time) == false;
}

Future<void> _updateNotification(
    FlutterLocalNotificationsPlugin plugin, ReminderModel reminder) async {
  await plugin.cancel(reminder.notificationId);
  return _scheduleNotification(plugin, reminder);
}

Future<void> _scheduleNotification(
    FlutterLocalNotificationsPlugin plugin, ReminderModel reminder) async {
  if (reminder == null || reminder.time == null) {
    return Future.value();
  }

  var notificationDetails = NotificationDetails(
      AndroidNotificationDetails('reminders', 'Task Reminders',
          'Notifications for Tasks you want to be reminded about'),
      IOSNotificationDetails());

  return plugin.schedule(reminder.notificationId, reminder.title,
      reminder.message, reminder.time, notificationDetails,
      payload: reminder.toJSON(), androidAllowWhileIdle: true);
}

ChangedReminders _extractChangedReminders(List<DocumentChange> documentChanges,
    Map<String, TaskModel> existingTasksMap, String userId) {
  var changedReminders = ChangedReminders();

  for (var change in documentChanges) {
    switch (change.type) {
      case DocumentChangeType.added:
        var reminder = _extractReminder(change.document, userId);
        if (reminder != null) {
          changedReminders.added.add(reminder);
        }
        break;
      case DocumentChangeType.modified:
        var existingTask = existingTasksMap[change.document.documentID];
        if (_didDeleteReminder(existingTask, change.document, userId)) {
          changedReminders.removed
              .add(ReminderModel.removed(change.document.documentID));
        } else if (_didCreateReminder(existingTask, change.document, userId)) {
          changedReminders.added.add(_extractReminder(change.document, userId));
        } else if (_didChange(existingTask, change.document, userId)) {
          changedReminders.modified
              .add(_extractReminder(change.document, userId));
        }
        break;
      case DocumentChangeType.removed:
        changedReminders.removed
            .add(ReminderModel.removed(change.document.documentID));
        break;
    }
  }

  return changedReminders;
}

bool _didCreateReminder(
    TaskModel existingTask, DocumentSnapshot doc, String userId) {
  var existingReminder = existingTask?.ownReminder;
  var incomingReminder = _extractReminder(doc, userId);

  if (existingReminder == null && incomingReminder != null) {
    return true;
  }

  if ((existingTask != null && existingTask.isDeleted == true) &&
      doc.data['isDeleted'] == false) {
    return true;
  }

  return false;
}

bool _didDeleteReminder(
    TaskModel existingTask, DocumentSnapshot doc, String userId) {
  var existingReminder = existingTask?.ownReminder;
  var incomingReminder = _extractReminder(doc, userId);

  if (existingReminder != null && incomingReminder == null) {
    return true;
  }

  if ((existingTask != null && existingTask.isDeleted == false) &&
      doc.data['isDeleted'] == true) {
    return true;
  }

  return false;
}

bool _didChange(TaskModel existingTask, DocumentSnapshot doc, String userId) {
  return _didChangeIsSeen(existingTask, doc, userId) ||
      _didChangeMessage(existingTask, doc, userId) ||
      _didChangeDate(existingTask, doc, userId);
}

bool _didChangeIsSeen(
    TaskModel existingTask, DocumentSnapshot doc, String userId) {
  var existingIsSeen = existingTask?.ownReminder?.isSeen;
  var incomingIsSeen = _extractReminder(doc, userId)?.isSeen;

  if (existingIsSeen == null && incomingIsSeen == null) {
    return false;
  }

  if (existingIsSeen != null && incomingIsSeen == null) {
    return true;
  }

  if (existingIsSeen == null && incomingIsSeen != null) {
    return true;
  }

  return existingIsSeen != incomingIsSeen;
}

bool _didChangeMessage(
    TaskModel existingTask, DocumentSnapshot doc, String userId) {
  var existingTaskName = existingTask?.taskName;
  var incomingTaskName = doc.data['taskName'];

  if (existingTaskName == null && incomingTaskName == null) {
    return false;
  }

  if (existingTaskName != null && incomingTaskName == null) {
    return true;
  }

  if (existingTaskName == null && incomingTaskName != null) {
    return true;
  }

  return existingTaskName != incomingTaskName;
}

bool _didChangeDate(
    TaskModel existingTask, DocumentSnapshot doc, String userId) {
  var existingDate = existingTask.ownReminder?.time;
  var incomingDate = _extractReminder(doc, userId)?.time;

  if (existingDate == null && incomingDate == null) {
    return false;
  }

  if (existingDate != null && incomingDate == null) {
    return true;
  }

  if (existingDate == null && incomingDate != null) {
    return true;
  }

  return !existingDate.isAtSameMomentAs(incomingDate);
}

bool _hasReminder(DocumentSnapshot taskDoc, String userId) {
  return taskDoc.data['reminders'] != null &&
      taskDoc.data['reminders'][userId] != null;
}

ReminderModel _extractReminder(DocumentSnapshot taskDoc, String userId) {
  if (_hasReminder(taskDoc, userId)) {
    return ReminderModel.fromMap(taskDoc.data['reminders'][userId]);
  }

  return null;
}

Future<Map<int, PendingNotificationRequest>> _getPendingDeviceNotificationsMap(
    FlutterLocalNotificationsPlugin plugin) async {
  var currentDeviceNotifications = await plugin.pendingNotificationRequests();

  return Map<int, PendingNotificationRequest>.fromIterable(
      currentDeviceNotifications,
      key: (item) {
        var request = item as PendingNotificationRequest;
        return request.id;
      },
      value: (item) => item as PendingNotificationRequest);
}

class ChangedReminders {
  final List<ReminderModel> removed = <ReminderModel>[];
  final List<ReminderModel> added = <ReminderModel>[];
  final List<ReminderModel> modified = <ReminderModel>[];
}
