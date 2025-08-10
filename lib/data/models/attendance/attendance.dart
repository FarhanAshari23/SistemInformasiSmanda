import 'package:new_sistem_informasi_smanda/domain/entities/attandance/attandance.dart';

class AttendanceModel {
  final String createdAt;

  AttendanceModel({
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'createdAt': createdAt,
    };
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      createdAt: map['createdAt'] ?? '',
    );
  }
}

extension AttendanceModelX on AttendanceModel {
  AttandanceEntity toEntity() {
    return AttandanceEntity(
      createdAt: createdAt,
    );
  }
}
