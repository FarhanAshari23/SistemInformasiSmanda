import '../../../domain/entities/news/news.dart';

class NewsModel {
  final int newsId;
  final int teacherId;
  final List<int> classId;
  final DateTime createdAt;
  final String title;
  final String description;
  final String teacherName;
  final String className;
  final bool? isGlobal;

  NewsModel({
    required this.classId,
    required this.teacherId,
    required this.className,
    required this.newsId,
    required this.createdAt,
    required this.title,
    required this.description,
    required this.teacherName,
    required this.isGlobal,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'id': newsId,
      'teacher_id': teacherId,
      'class_id': classId,
      'class_name': className,
      'created_at': createdAt.toUtc(),
      'title': title,
      "description": description,
      "teacher_name": teacherName,
      "is_global": isGlobal,
    };

    data.removeWhere((key, value) {
      if (value == null) return true;
      if (value == 0) return true;
      if (value is Iterable && value.isEmpty) return true;
      if (value is String && value.isEmpty) return true;
      return false;
    });

    return data;
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      classId: map['class_id'] ?? [],
      teacherId: map['teacher_id'] ?? 0,
      className: map['class_name'] ?? "",
      newsId: map["id"] ?? 0,
      createdAt: map["created_at"] ?? DateTime.now().toUtc(),
      title: map['title'] ?? "",
      description: map["description"] ?? '',
      teacherName: map["teacher_name"] ?? "",
      isGlobal: map["is_global"] ?? false,
    );
  }
}

extension NewsModelX on NewsModel {
  NewsEntity toEntity() {
    return NewsEntity(
      classId: classId,
      className: className,
      createdAt: createdAt,
      description: description,
      isGlobal: isGlobal,
      newsId: newsId,
      teacherId: teacherId,
      teacherName: teacherName,
      title: title,
    );
  }

  static NewsModel fromEntity(NewsEntity entity) {
    return NewsModel(
      classId: entity.classId ?? [],
      className: entity.className ?? '',
      createdAt: entity.createdAt ?? DateTime.now().toUtc(),
      description: entity.description ?? '',
      isGlobal: entity.isGlobal ?? false,
      newsId: entity.newsId ?? 0,
      teacherId: entity.teacherId ?? 0,
      teacherName: entity.teacherName ?? '',
      title: entity.title ?? '',
    );
  }
}
