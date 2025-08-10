String extractName(String name) {
  List<String> nameParts = name.split(" ");

  if (nameParts.length > 1) {
    return nameParts[1];
  } else {
    return nameParts[0];
  }
}
