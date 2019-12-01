import 'package:handball_flutter/configValues.dart';
import 'package:handball_flutter/models/Reminder.dart';
import 'package:handball_flutter/utilities/truncateString.dart';

Map<String, ReminderModel> buildNewRemindersMap(
    String taskId, String taskName, String userId, DateTime reminderTime) {
  if (reminderTime == null) {
    return <String, ReminderModel>{};
  }

  var reminder = ReminderModel(
    message: truncateString(taskName, taskReminderMessageLength),
    originTaskId: taskId,
    time: reminderTime,
    title: taskReminderTitle,
    isSeen: false,
    userId: userId,
  );

  return <String, ReminderModel>{
    userId: reminder,
  };
}