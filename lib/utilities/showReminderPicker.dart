import 'package:flutter/material.dart';

Future<DateTime> showReminderPicker(
    {@required firstDate,
    @required lastDate,
    @required context,
    @required initialDate}) async {
  var dateResult = await showDatePicker(
    firstDate: firstDate,
    lastDate: lastDate,
    context: context,
    initialDate: initialDate ?? DateTime.now(),
  );

  if (dateResult == null) {
    return null;
  }

  var timeResult = await showTimePicker(
    context: context,
    initialTime: _roundTimeForward(DateTime.now()),
  );

  if (dateResult != null && timeResult != null) {
    var result = dateResult.subtract(Duration(
        hours: dateResult.hour,
        minutes: dateResult.minute,
        seconds: dateResult.second));
    result = result
        .add(Duration(hours: timeResult.hour, minutes: timeResult.minute));

    return result;
  }

  return null;
}

TimeOfDay _roundTimeForward(DateTime time) {
  if (time.minute % 5 == 0) {
    return TimeOfDay.fromDateTime(time);
  }

  var minute = time.minute;
  var roundForwardMinute = 0;

  while (minute % 5 != 0) {
    minute++;
    roundForwardMinute++;
  }

  return TimeOfDay.fromDateTime(
      time.add(Duration(minutes: roundForwardMinute)));
}
