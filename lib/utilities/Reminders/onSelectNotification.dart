import 'package:handball_flutter/models/Reminder.dart';
import 'package:handball_flutter/redux/appState.dart';
import 'package:handball_flutter/redux/syncActions.dart';
import 'package:handball_flutter/utilities/Reminders/clearTaskReminder.dart';
import 'package:redux/redux.dart';

Future onSelectNotification(String payload, Store<AppState> store) async {
  if (payload == null) {
    return Future.value();
  }

  var reminder = ReminderModel.fromJSON(payload);
  var taskId = reminder.originTaskId;

  var task = store.state.tasksById[taskId];

  if (task == null || task.isDeleted == true) {
    // Show Task Deleted.
  } else {
    clearTaskReminder(taskId, task.project, store.state.user.userId);
    store.dispatch(SelectProject(task.project));
    store.dispatch(OpenTaskInspector(taskEntity: task));
  }

  return Future.value();
}