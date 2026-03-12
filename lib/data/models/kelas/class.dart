import 'dart:convert';

import '../../../domain/entities/kelas/kelas.dart';
import '../schedule/day.dart';

class KelasModel {
  final int id, teacherId, sequence, degree, totalStudent;
  final String className, teacherName, teacherNip;
  final List<DayModel> schedules;

  KelasModel({
    required this.className,
    required this.id,
    required this.teacherId,
    required this.sequence,
    required this.totalStudent,
    required this.teacherName,
    required this.teacherNip,
    required this.degree,
    required this.schedules,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'classes': {
        'id': id,
        'name': className,
        'sequence': sequence,
        'degree': degree,
        'total_student': totalStudent,
        'teacher_id': teacherId,
        'nama_wali_kelas': teacherName,
        'nip_wali_kelas': teacherNip,
      },
      'schedules': schedules.map((x) => x.toMap()).toList(),
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

  factory KelasModel.fromMap(Map<String, dynamic> map) {
    final classData = map['classes'] ?? {};

    return KelasModel(
      className: classData['name'] ?? '',
      degree: classData['degree'] ?? 0,
      id: classData['id'] ?? 0,
      sequence: classData['sequence'] ?? 0,
      teacherId: classData['teacher_id'] ?? 0,
      teacherName: classData['nama_wali_kelas'] ?? '',
      teacherNip: classData['nip_wali_kelas'] ?? '',
      totalStudent: classData['total_student'] ?? 0,
      schedules: map['schedules'] != null
          ? List<DayModel>.from(
              (map['schedules'] as List).map((x) => DayModel.fromMap(x)),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory KelasModel.fromJson(String source) =>
      KelasModel.fromMap(json.decode(source));
}

extension KelasModelX on KelasModel {
  KelasEntity toEntity() {
    return KelasEntity(
      className: className,
      degree: degree,
      id: id,
      sequence: sequence,
      teacherId: teacherId,
      teacherName: teacherName,
      teacherNip: teacherNip,
      totalStudent: totalStudent,
      schedules: schedules.map((x) => x.toEntity()).toList(),
    );
  }
}

extension KelasEntityX on KelasEntity {
  KelasModel fromEntity() {
    return KelasModel(
      className: className ?? '',
      degree: degree ?? 0,
      id: id ?? 0,
      sequence: sequence ?? 0,
      teacherId: teacherId ?? 0,
      teacherName: teacherName ?? '',
      teacherNip: teacherNip ?? '',
      totalStudent: totalStudent ?? 0,
      schedules: schedules
              ?.map((x) => DayModel(
                    day: x.day ?? '',
                    startTime: x.startTime ?? '',
                    endTime: x.endTime ?? '',
                    teacherId: x.teacherId ?? 0,
                    subjectId: x.subjectId ?? 0,
                    classId: x.classId ?? 0,
                    subjectName: x.subjectName ?? '',
                    teacherName: x.teacherName ?? '',
                  ))
              .toList() ??
          [],
    );
  }
}
