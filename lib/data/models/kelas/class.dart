import 'dart:convert';

import 'package:new_sistem_informasi_smanda/domain/entities/kelas/kelas.dart';

class KelasModel {
  final int id, teacherId, sequence, degree, totalStudent;
  final String className, teacherName, teacherNip;

  KelasModel({
    required this.className,
    required this.id,
    required this.teacherId,
    required this.sequence,
    required this.totalStudent,
    required this.teacherName,
    required this.teacherNip,
    required this.degree,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': className,
      'sequence': sequence,
      'degree': degree,
      'total_student': totalStudent,
      'teacher_id': teacherId,
      'nama_wali_kelas': teacherName,
      'nip_wali_kelas': teacherNip,
    };
  }

  factory KelasModel.fromMap(Map<String, dynamic> map) {
    return KelasModel(
      className: map['name'],
      degree: map['degree'],
      id: map['id'],
      sequence: map['sequence'],
      teacherId: map['teacher_id'],
      teacherName: map['nama_wali_kelas'],
      teacherNip: map['nip_wali_kelas'],
      totalStudent: map['total_student'],
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
    );
  }
}
