import 'package:intl/intl.dart';

String getDateTimeText(DateTime date, String hintText) {
  if (date == null) {
    return hintText ?? 'Pick date';
  }

  var dateFormater = new DateFormat('EEEE MMMM d');
  var timeFormatter = new DateFormat('jm');
  return '${dateFormater.format(date)} at ${timeFormatter.format(date)}';
}
