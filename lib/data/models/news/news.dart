import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:new_sistem_informasi_smanda/domain/entities/news/news.dart';

class NewsModel {
  String? uIdNews;
  final Timestamp createdAt;
  final String title;
  final String content;
  final String from;
  final String to;

  NewsModel({
    this.uIdNews,
    required this.createdAt,
    required this.title,
    required this.content,
    required this.from,
    required this.to,
  });

  Map<String, dynamic> toMap() {
    return {
      'uIdNews': uIdNews,
      'createdAt': createdAt,
      'title': title,
      'content': content,
      'from': from,
      'to': to,
    };
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      createdAt: map['createdAt'] ?? DateTime.now(),
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      from: map['from'] ?? '',
      to: map['to'] ?? '',
      uIdNews: map['uIdNews'] ?? '',
    );
  }
}

extension NewsModelX on NewsModel {
  NewsEntity toEntity() {
    return NewsEntity(
      uIdNews: uIdNews!,
      createdAt: createdAt,
      title: title,
      content: content,
      from: from,
      to: to,
    );
  }
}
