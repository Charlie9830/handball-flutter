DateTime coerceDate(String date) {
  return date == null || date == ''
      ? null
      : DateTime.parse(date);
}
