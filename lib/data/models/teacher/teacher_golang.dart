import 'dart:convert';

import '../../../domain/entities/teacher/teacher_golang.dart';

class TeacherGolangModel {
  final int id, gender;
  final List<int>? tasksId;
  final String name, nip, email;
  final String? waliKelas;
  final DateTime birthDate;
  final List<String>? tasksName;

  TeacherGolangModel({
    required this.id,
    required this.gender,
    required this.tasksId,
    required this.name,
    required this.nip,
    required this.email,
    required this.waliKelas,
    required this.birthDate,
    required this.tasksName,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'id': id,
      'nip': nip,
      'name': name,
      'additional_tasks': tasksId,
      'wali_kelas': waliKelas,
      'gender': gender,
      'birth_date': birthDate.toUtc().toIso8601String(),
      'email': email,
      'tugas_tambahan': tasksName,
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

  factory TeacherGolangModel.fromMap(Map<String, dynamic> map) {
    return TeacherGolangModel(
      id: map['id'] ?? 0,
      nip: map['nip'] ?? '',
      name: map['name'] ?? '',
      gender: map['gender'] ?? 0,
      birthDate: map['birth_date'] != null && map['birth_date'] != ''
          ? DateTime.parse(map['birth_date'])
          : DateTime(2000, 1, 1),
      email: map['email'] ?? '',
      waliKelas: map['wali_kelas'] ?? '',
      tasksId: map['additional_tasks'] ?? '',
      tasksName: map['tugas_tambahan'] ?? [],
    );
  }

  String toJson() => json.encode(toMap());

  factory TeacherGolangModel.fromJson(String source) =>
      TeacherGolangModel.fromMap(json.decode(source));
}

extension TeacherGolangModelX on TeacherGolangModel {
  TeacherGolangEntity toEntity() {
    return TeacherGolangEntity(
      id: id,
      birthDate: birthDate,
      email: email,
      gender: gender,
      name: name,
      nip: nip,
      tasksId: tasksId,
      tasksName: tasksName,
      waliKelas: waliKelas,
    );
  }

  static TeacherGolangModel fromEntity(TeacherGolangEntity entity) {
    return TeacherGolangModel(
      birthDate: entity.birthDate ?? DateTime.now(),
      email: entity.email ?? '',
      gender: entity.gender ?? 0,
      id: entity.id ?? 0,
      name: entity.name ?? '',
      nip: entity.nip ?? '',
      tasksId: entity.tasksId ?? [],
      tasksName: entity.tasksName ?? [],
      waliKelas: entity.waliKelas ?? '',
    );
  }
}
