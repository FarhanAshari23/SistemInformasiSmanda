import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/attandance/attandance.dart';

class AttendanceModel {
  final String createdAt;
  final Timestamp timestamp;

  AttendanceModel({
    required this.createdAt,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
      'timestamp': timestamp,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      createdAt: map['createdAt'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }
}

extension AttendanceModelX on AttendanceModel {
  AttandanceEntity toEntity() {
    return AttandanceEntity(
      createdAt: createdAt,
      timestamp: timestamp,
    );
  }
}
