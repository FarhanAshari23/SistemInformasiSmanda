String getFirstRealName(String fullName) {
  if (fullName.isEmpty) return '';

  final List<String> prefixTitles = [
    'Dr',
    'Dr.',
    'Dra',
    'Drs',
    'Drs.',
    'H',
    'H.',
    'Hj',
    'Hj.',
    'Prof',
    'Prof.',
    'Ir',
    'Ir.',
    'Kha',
    'Kha.'
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
