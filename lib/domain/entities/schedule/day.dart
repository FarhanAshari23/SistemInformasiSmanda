class DayEntity {
  String? day;
  String? startTime;
  String? endTime;
  String? teacherName;
  String? subjectName;
  int? teacherId, subjectId, classId;

  DayEntity({
    this.classId,
    this.day,
    this.endTime,
    this.startTime,
    this.subjectId,
    this.teacherId,
    this.subjectName,
    this.teacherName,
  });

  DayEntity copyWith({
    String? day,
    String? startTime,
    String? endTime,
    int? teacherId,
    int? subjectId,
    int? classId,
    String? teacherName,
    String? subjectName,
  }) {
    return DayEntity(
      classId: classId ?? this.classId,
      day: day ?? this.day,
      endTime: endTime ?? this.endTime,
      startTime: startTime ?? this.startTime,
      subjectId: subjectId ?? this.subjectId,
      teacherId: teacherId ?? this.teacherId,
      subjectName: subjectName ?? this.subjectName,
      teacherName: teacherName ?? this.teacherName,
    );
  }
}
