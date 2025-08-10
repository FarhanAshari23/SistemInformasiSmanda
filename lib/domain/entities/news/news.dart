import 'package:cloud_firestore/cloud_firestore.dart';

class NewsEntity {
  String? uIdNews;
  Timestamp? createdAt;
  final String title;
  final String content;
  final String from;
  final String to;

  NewsEntity({
    this.uIdNews,
    this.createdAt,
    required this.title,
    required this.content,
    required this.from,
    required this.to,
  });
}
