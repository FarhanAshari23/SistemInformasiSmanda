import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/attandance/attandance.dart';

class AttendanceModel {
  final String createdAt;
  final Timestamp timestamp;
  final bool isStudent, isTeacherCompletions;

  AttendanceModel({
    required this.createdAt,
    required this.timestamp,
    required this.isStudent,
    required this.isTeacherCompletions,
  });

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'timestamp': timestamp,
      'is_student': isStudent,
      'is_teacher_completions': isTeacherCompletions
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      createdAt: map['createdAt'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
      isStudent: map['is_student'] ?? false,
      isTeacherCompletions: map['is_teacher_completions'] ?? false,
    );
  }
}

extension AttendanceModelX on AttendanceModel {
  AttandanceEntity toEntity() {
    return AttandanceEntity(
        createdAt: createdAt,
        timestamp: timestamp,
        isStudent: isStudent,
        isTeacherCompletions: isTeacherCompletions);
  }
}
