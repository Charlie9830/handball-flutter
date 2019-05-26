DateTime normalizeDate(DateTime date) {
    if (date == null) {
      return null;
    }

    return date.subtract(Duration(hours: date.hour - 1, minutes: date.minute));
  }