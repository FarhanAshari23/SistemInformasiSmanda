import 'dart:convert';
import '../../../domain/entities/schedule/day.dart';

class DayModel {
  final String day;
  final String startTime;
  final String endTime;
  final String teacherName;
  final String subjectName;
  final String className;
  final int teacherId, subjectId, classId;

  DayModel({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.teacherId,
    required this.classId,
    required this.subjectId,
    required this.subjectName,
    required this.teacherName,
    required this.className,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'teacher_id': teacherId,
      'subject_id': subjectId,
      'class_id': classId,
      'teacher_name': teacherName,
      'subject_name': subjectName,
      'class_name': className,
    };
  }

  Map<String, dynamic> toCreateRequestMap() {
    return <String, dynamic>{
      'day': day,
      'start_time': startTime,
      'end_time': endTime,
      'teacher_id': teacherId,
      'subject_id': subjectId,
    };
  }

  factory DayModel.fromMap(Map<String, dynamic> map) {
    return DayModel(
      day: map['day'] ?? '',
      startTime: map['start_time'] ?? '',
      endTime: map['end_time'] ?? '',
      teacherName: map['teacher_name'] ?? '',
      subjectName: map['subject_name'] ?? '',
      teacherId: map['teacher_id']?.toInt() ?? 0,
      subjectId: map['subject_id']?.toInt() ?? 0,
      classId: map['class_id']?.toInt() ?? 0,
      className: map['class_name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DayModel.fromJson(String source) =>
      DayModel.fromMap(json.decode(source));
}

extension DayXModel on DayModel {
  DayEntity toEntity() {
    return DayEntity(
      day: day,
      startTime: startTime,
      endTime: endTime,
      teacherId: teacherId,
      subjectId: subjectId,
      classId: classId,
      subjectName: subjectName,
      teacherName: teacherName,
      className: className,
    );
  }
}

extension DayXEntity on DayEntity {
  DayModel fromEntity() {
    return DayModel(
      day: day ?? '',
      startTime: startTime ?? '',
      endTime: endTime ?? '',
      teacherId: teacherId ?? 0,
      subjectId: subjectId ?? 0,
      classId: classId ?? 0,
      subjectName: subjectName ?? '',
      teacherName: teacherName ?? '',
      className: className ?? '',
    );
  }
}
