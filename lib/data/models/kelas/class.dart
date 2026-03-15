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

  Map<String, dynamic> toCreateRequestMap() {
    return {
      "classes": {
        "name": className,
        "sequence": sequence,
        "degree": degree,
        "teacher_id": teacherId,
      },
      "schedules": schedules.map((s) => s.toCreateRequestMap()).toList(),
    };
  }

  Map<String, dynamic> toUpdateRequestMap() {
    return {
      "name": className,
      "sequence": sequence,
      "degree": degree,
      "teacher_id": teacherId,
      "schedules": schedules.map((s) => s.toCreateRequestMap()).toList(),
    };
  }

  factory KelasModel.fromMap(Map<String, dynamic> map) {
    final data = map.containsKey('classes') ? map['classes'] : map;

    return KelasModel(
      id: data['id'] ?? 0,
      className: data['name'] ?? '',
      sequence: data['sequence'] ?? 0,
      degree: data['degree'] ?? 0,
      totalStudent: data['total_student'] ?? 0,
      teacherId: data['teacher_id'] ?? 0,
      teacherName: data['nama_wali_kelas'] ?? '',
      teacherNip: data['nip_wali_kelas'] ?? '',
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
