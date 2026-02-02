import 'package:cloud_firestore/cloud_firestore.dart';

class AttandanceEntity {
  final String createdAt;
  final Timestamp timestamp;
  final bool isStudent, isTeacherCompletions;

  AttandanceEntity({
    required this.createdAt,
    required this.timestamp,
    required this.isStudent,
    required this.isTeacherCompletions,
  });
}
