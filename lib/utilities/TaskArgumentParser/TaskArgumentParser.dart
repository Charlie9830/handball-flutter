import 'package:handball_flutter/models/Member.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class TaskArgumentParser {
  final List<MemberModel> projectMembers;

  TaskArgumentParser({
    @required this.projectMembers,
  });

  static final formatters = <DateFormat>[
    DateFormat('d/M/y'), // 21/8/1990
    DateFormat('d/M'), // 21/8
    DateFormat('d M y'), // 21 8 1990
    DateFormat('d M'), // 21 8
    DateFormat('d-m-y'), // 21-8-1990,
    DateFormat('d-m'), // 21-8
    DateFormat('d MMMM y'), // 21 August 1990
    DateFormat('d MMMM'), // 21 August
    DateFormat('d MMM y'), // 21 aug 1990
    DateFormat('d MMM'), // 21 aug
    DateFormat('d-MMMM-y'), // 21-August-1990
    DateFormat('d-MMMM'), // 21-August
    DateFormat('d-MMM-y'), // 21-aug-1990
    DateFormat('d-MMM'), // 21-aug
  ];

  static final argsPattern = RegExp(r" -(d |a |i |hp |n |\bnote\b |\bdetails\b )");
  static final daysForwardPattern = RegExp(r"(\d|\d\d)[d]");
  static final weeksForwardPattern = RegExp(r"(\d|\d\d)[w]");

  static bool hasArguments(String value) {
    return argsPattern.firstMatch(value) != null;
  }

  static String trimArguments(String value) {
    var firstMatch = argsPattern.firstMatch(value);

    if (firstMatch == null) {
      return value;
    }

    return value.substring(0, firstMatch.start).trim();
  }

  Future<ArgumentMap> parseTextForArguments(String text) {
    var matches = argsPattern.allMatches(text).toList();
    if (matches.length == 0) {
      return Future.value(null);
    }

    var argMap = ArgumentMap(
        argStartIndex: matches.first.start,
        prunedText: text.substring(0, matches.first.start));

    return Future(() {
      for (int i = 0; i < matches.length; i++) {
        var match = matches[i];
        var valueLastIndex =
            i + 1 < matches.length ? matches[i + 1].start : text.length;

        var value = text.substring(match.end, valueLastIndex);
        var matchType = _parseMatchType(text, match.start, match.end);

        switch (matchType) {
          case ArgumentType.assignment:
            argMap.assignmentIds = _tryParseAssignment(value.toLowerCase(), projectMembers);
            break;
          case ArgumentType.dueDate:
            argMap.dueDate = _tryParseFuzzyDateString(value.toLowerCase());
            break;
          case ArgumentType.note:
            argMap.note = value;
            break;
          case ArgumentType.priority:
            argMap.isHighPriority = true;
            break;
        }
      }

      return Future.value(argMap);
    });
  }

  List<String> _tryParseAssignment(
      String value, List<MemberModel> projectMembers) {
    if (projectMembers == null || projectMembers.isEmpty) {
      return null;
    }

    var strings = value.split(RegExp(r"[+]|\s|, "));

    var userIds = <String>[];
    for (var string in strings) {
      var result = _tryMatchDisplayName(string, projectMembers);
      if (result != null) {
        userIds.add(result);
      }
    }

    if (userIds.length == 0) {
      return null;
    }

    return userIds.toSet().toList();
  }

  String _tryMatchDisplayName(String value, List<MemberModel> members) {
    for (var member in members) {
      if (member.displayName.toLowerCase().contains(value)) {
        return member.userId;
      }
    }

    return null;
  }

  DateTime _tryParseDurationForward(String value) {
    if (weeksForwardPattern.hasMatch(value)) {
      var weeksForwardString = weeksForwardPattern.firstMatch(value).group(1);
      if (weeksForwardString == null) {
        return null;
      }

      var weeksForward = int.tryParse(weeksForwardString);
      if (weeksForward == null) {
        return null;
      }

      return DateTime.now().add(Duration(days: weeksForward * 7));
    }

    if (daysForwardPattern.hasMatch(value)) {
      var daysForwardString = daysForwardPattern.firstMatch(value).group(1);
      if (daysForwardString == null) {
        return null;
      }

      var daysForward = int.tryParse(daysForwardString);
      if (daysForward == null) {
        return null;
      }

      return DateTime.now().add(Duration(days: daysForward));
    }

    return null;
  }

  DateTime _tryParseFuzzyDateString(String value) {
    DateTime date;

    // Try to parse as a phrase.
    date = _tryParsePhrase(value);
    if (date != null) {
      return date;
    }

    // Try to parse as a weekday.
    date = _adjustToWeekday(value);
    if (date != null) {
      return date;
    }

    // Try to parse as timeForward.
    date = _tryParseDurationForward(value);
    if (date != null) {
      return date;
    }

    // Try to parse as a Date
    date = _tryParseFuzzyDate(value);
    if (date != null) {
      return date;
    }

    return date;
  }

  DateTime _tryParsePhrase(String value) {
    if (value.contains('tod')) {
      return DateTime.now();
    }

    if (value.contains('tom')) {
      return DateTime.now().add(Duration(days: 1));
    }

    if (value.contains('yesterday')) {
      return DateTime.now().subtract(Duration(days: 1));
    }

    return null;
  }

  DateTime _tryParseFuzzyDate(String value) {
    DateTime date;

    for (var format in formatters) {
      try {
        date = format.parseLoose(value);
        break;
      } catch (error) {
        if (error is FormatException) {
          continue;
        }
      }
    }

    if (date == null) {
      return null;
    }

    if (date.year == 1970) {
      // No Year was provided. Bump it to the current Year.
      // TODO: This is a bit Naive. It should prefer Dates in the future, otherwise it might bump to a past date.
      var formatter = DateFormat('d/M/y');
      date = formatter.parse(formatter
          .format(date)
          .replaceFirst('/1970', '/${DateTime.now().year}'));
    }

    return date;
  }

  DateTime _adjustToWeekday(String value) {
    value = value.toLowerCase();

    // Extract the deiredWeekday integer by checking against the weekdayKeywordMap
    var desiredWeekday = 0;
    if (value.contains('sun') || value.contains('sundayu')) {
      desiredWeekday = 7;
    }

    if (value.contains('mon') || value.contains('monday')) {
      desiredWeekday = 1;
    }

    if (value.contains('tues') || value.contains('tuesday')) {
      desiredWeekday = 2;
    }

    if (value.contains('wed') || value.contains('wednesday')) {
      desiredWeekday = 3;
    }

    if (value.contains('thurs') || value.contains('thursday')) {
      desiredWeekday = 4;
    }

    if (value.contains('friday') || value.contains('fri')) {
      desiredWeekday = 5;
    }

    if (value.contains('saturday') || value.contains('sat')) {
      desiredWeekday = 6;
    }

    if (desiredWeekday == 0) {
      // Didn't match any keywords.
      return null;
    }

    var now = DateTime.now();
    if (now.weekday < desiredWeekday) {
      // Haven't reached that day yet.
      return now
          .subtract(Duration(days: now.weekday))
          .add(Duration(days: desiredWeekday));
    }

    if (now.weekday == desiredWeekday) {
      return now;
    }

    if (now.weekday > desiredWeekday) {
      // That day has already past. Advance to next instance.
      return now.add(Duration(days: (7 - now.weekday) + desiredWeekday));
    }

    return null;
  }

  ArgumentType _parseMatchType(
      String inputString, int startIndex, int endIndex) {
    switch (inputString.substring(startIndex, endIndex).toLowerCase()) {
      case ' -d ':
        return ArgumentType.dueDate;

      case ' -a ':
        return ArgumentType.assignment;

      case ' -i ':
        return ArgumentType.priority;

      case ' -hp ':
        return ArgumentType.priority;

      case ' -n ':
        return ArgumentType.note;

      case ' -note ':
        return ArgumentType.note;

      case ' -details ':
        return ArgumentType.note;

      default:
        throw FormatException('Could not parse match type: inputString is $inputString');
    }
  }
}

enum Weekdays { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

enum ArgumentType { assignment, dueDate, note, priority }

class ArgumentMatch {
  final ArgumentType type;
  final int startIndex;

  ArgumentMatch({this.type, this.startIndex});
}

class ArgumentMap {
  int argStartIndex;
  String prunedText;
  List<String> assignmentIds;
  DateTime dueDate;
  String note;
  bool isHighPriority;

  ArgumentMap({
    this.argStartIndex,
    this.assignmentIds,
    this.dueDate,
    this.note,
    this.isHighPriority,
    this.prunedText,
  });
}
