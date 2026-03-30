import 'dart:convert';

import '../../../domain/entities/ekskul/member.dart';

class MemberModel {
  final int id, gender;
  final String name, nisn, role, religion, ekskulName;

  MemberModel({
    required this.id,
    required this.name,
    required this.nisn,
    required this.role,
    required this.religion,
    required this.gender,
    required this.ekskulName,
  });

  Map<String, dynamic> toMap() {
    return {
      'student_id': id,
      'student_name': name,
      'student_nisn': nisn,
      'student_religion': religion,
      'student_gender': gender,
      'role': role,
      'extracurricular_name': ekskulName,
    };
  }

  Map<String, dynamic> createMap() {
    return {
      'student_id': id,
      'role': role,
    };
  }

  factory MemberModel.fromMap(Map<String, dynamic> map) {
    return MemberModel(
      id: map['student_id'] ?? 0,
      nisn: map['student_nisn'] ?? '',
      name: map['student_name'] ?? '',
      role: map['role'] ?? '',
      gender: map['student_gender'] ?? 0,
      religion: map['student_religion'] ?? '',
      ekskulName: map['extracurricular_name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory MemberModel.fromJson(String source) =>
      MemberModel.fromMap(json.decode(source));
}

extension MemberModelX on MemberModel {
  MemberEntity toEntity() {
    return MemberEntity(
      id: id,
      name: name,
      nisn: nisn,
      role: role,
      gender: gender,
      religion: religion,
      ekskulName: ekskulName,
    );
  }

  static MemberModel fromEntity(MemberEntity entity) {
    return MemberModel(
      id: entity.id ?? 0,
      name: entity.name ?? '',
      nisn: entity.nisn ?? '',
      role: entity.role ?? '',
      gender: entity.gender ?? 0,
      religion: entity.religion ?? '',
      ekskulName: entity.ekskulName ?? '',
    );
  }
}
