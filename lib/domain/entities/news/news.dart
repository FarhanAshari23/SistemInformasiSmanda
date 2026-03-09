class NewsEntity {
  int? newsId;
  int? teacherId;
  List<int>? classId;
  DateTime? createdAt;
  String? title;
  String? description;
  String? teacherName;
  String? className;
  bool? isGlobal;

  NewsEntity({
    this.newsId,
    this.teacherId,
    this.classId,
    this.createdAt,
    this.title,
    this.description,
    this.teacherName,
    this.className,
    this.isGlobal,
  });

  NewsEntity copyWith({
    int? newsId,
    int? teacherId,
    List<int>? classId,
    DateTime? createdAt,
    String? title,
    String? description,
    String? teacherName,
    String? className,
    bool? isGlobal,
  }) {
    return NewsEntity(
      newsId: newsId ?? this.newsId,
      teacherId: teacherId ?? this.teacherId,
      classId: classId ?? this.classId,
      createdAt: createdAt ?? this.createdAt,
      title: title ?? this.title,
      description: description ?? this.description,
      teacherName: teacherName ?? this.teacherName,
      className: className ?? this.className,
      isGlobal: isGlobal ?? this.isGlobal,
    );
  }
}
