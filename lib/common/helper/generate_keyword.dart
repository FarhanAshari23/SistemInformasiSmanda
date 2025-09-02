import 'package:flutter/material.dart';

List<String> generateKeywords(String name) {
  final List<String> keywords = [];
  final List<String> words = name.toLowerCase().split(" ");

  for (var word in words) {
    String prefix = "";
    for (var char in word.characters) {
      prefix += char;
      keywords.add(prefix);
    }
  }

  // tambahkan juga full name (biar bisa detect langsung keseluruhan)
  keywords.add(name.toLowerCase());

  return keywords.toSet().toList(); // hilangkan duplikat
}
