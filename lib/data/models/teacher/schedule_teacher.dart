import 'dart:convert';

import 'package:new_sistem_informasi_smanda/domain/entities/teacher/schedule_teacher.dart';

class ScheduleTeacherModel {
  final String hari;
  final String kegiatan;
  final String jam;
  final String kelas;

  ScheduleTeacherModel({
    required this.hari,
    required this.kegiatan,
    required this.jam,
    required this.kelas,
  });

  Map<String, dynamic> toMap() {
    return {
      'hari': hari,
      'kegiatan': kegiatan,
      'jam': jam,
      'kelas': kelas,
    };
  }

  factory ScheduleTeacherModel.fromMap(Map<String, dynamic> map) {
    return ScheduleTeacherModel(
      kegiatan: map["kegiatan"] ?? '',
      jam: map["jam"] ?? '',
      hari: map["hari"] ?? '',
      kelas: map["kelas"] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleTeacherModel.fromJson(String source) =>
      ScheduleTeacherModel.fromMap(json.decode(source));
}

extension ScheduleTeacherModelX on ScheduleTeacherModel {
  ScheduleTeacherEntity toEntity() {
    return ScheduleTeacherEntity(
      hari: hari,
      kegiatan: kegiatan,
      jam: jam,
      kelas: kelas,
    );
  }

  static ScheduleTeacherModel fromEntity(ScheduleTeacherEntity entity) {
    return ScheduleTeacherModel(
      hari: entity.hari,
      kegiatan: entity.kegiatan,
      jam: entity.jam,
      kelas: entity.kelas,
    );
  }
}
