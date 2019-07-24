bool isSameTime(DateTime a, DateTime b) {
  if (a == null && b == null) {
    return true;
  }

  if ( a == null && b != null) {
    return false;
  }

  if ( a != null && b == null) {
    return false;
  }

  return a.isAtSameMomentAs(b);
}