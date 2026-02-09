String capitalizeName(String input) {
  if (input.trim().isEmpty) return input;

  return input.toLowerCase().split(RegExp(r'\s+')).map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }).join(' ');
}
