DateTime coerceDate(String dateAdded) {
  return dateAdded == null || dateAdded == ''
      ? null
      : DateTime.parse(dateAdded);
}
