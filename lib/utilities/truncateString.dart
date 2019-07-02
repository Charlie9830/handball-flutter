String truncateString(String input, [int desiredLength = 7]) {
  if (input == null || input.trim().length == 0) {
    return '';
  }

  input = input.trim();

  if (input.length <= desiredLength) {
    return input;
  }
  return '${input.substring(0, desiredLength)}...';
}