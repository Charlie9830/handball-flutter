List<String> coerceStringList(List<dynamic> stringList) {
    if (stringList == null) {
      return null;
    }

    return List<String>.from(stringList);
  }