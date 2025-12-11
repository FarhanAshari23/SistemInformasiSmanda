String getFirstRealName(String fullName) {
  if (fullName.isEmpty) return '';

  final prefixTitles = [
    'dr',
    'dr.',
    'dra',
    'dra.',
    'drs',
    'drs.',
    'h',
    'h.',
    'hj',
    'hj.',
    'prof',
    'prof.',
    'ir',
    'ir.',
    'kha',
    'kha.',
  ];

  final parts = fullName.toLowerCase().split(RegExp(r'\s+'));

  for (var word in parts) {
    // jika bukan gelar → return word
    if (!prefixTitles.contains(word)) {
      return _capitalize(word);
    }
  }

  return '';
}

// optional helper biar huruf kapital bagus
String _capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1).toLowerCase();
}
