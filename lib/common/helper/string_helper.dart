import 'dart:io';

class StringHelper {
  static List<int> extractFirstAndLastNumbers(String input) {
    final RegExp regExp = RegExp(r'\d+');
    final Iterable<RegExpMatch> matches = regExp.allMatches(input);

    if (matches.isEmpty) return [];

    int first = int.parse(matches.first.group(0)!);
    int last = int.parse(matches.last.group(0)!);

    return [first, last];
  }

  static String capitalizeName(String input) {
    if (input.trim().isEmpty) return input;

    return input.toLowerCase().split(RegExp(r'\s+')).map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  static Future<bool> isUrlReachable(String url) async {
    try {
      final uri = Uri.parse(url);

      final request = await HttpClient().headUrl(uri);
      final response = await request.close();

      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (e) {
      return false;
    }
  }

  static String extractName(String name) {
    List<String> nameParts = name.split(" ");

    if (nameParts.length > 1) {
      return nameParts[1];
    } else {
      return nameParts[0];
    }
  }

  static String getFirstRealName(String fullName) {
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
      if (!prefixTitles.contains(word)) {
        return _capitalize(word);
      }
    }

    return '';
  }

  static String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }

  static String maskEmail(String email, {int maskLength = 5}) {
    final atIndex = email.indexOf('@');
    if (atIndex == -1) return email; // bukan email valid

    final localPart = email.substring(0, atIndex);
    final domainPart = email.substring(atIndex);

    if (localPart.length <= maskLength) {
      return '*' * localPart.length + domainPart;
    }

    final visiblePart = localPart.substring(0, localPart.length - maskLength);
    final maskedPart = '*' * maskLength;

    return visiblePart + maskedPart + domainPart;
  }
}
