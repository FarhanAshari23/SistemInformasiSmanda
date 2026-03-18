import 'dart:convert';

import '../../../domain/entities/ekskul/advisor.dart';

class AdvisorModel {
  final int id, gender;
  final String name, nip, status;
  final DateTime birthDate;

  AdvisorModel({
    required this.id,
    required this.name,
    required this.nip,
    required this.birthDate,
    required this.gender,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'teacher_id': id,
      'teacher_name': name,
      'teacher_nip': nip,
      'teacher_birth_date': birthDate.toUtc().toIso8601String(),
      'teacher_gender': gender,
    };
  }

  Map<String, dynamic> createMap() {
    return {
      'teacher_id': id,
      'status': status,
    };
  }

  factory AdvisorModel.fromMap(Map<String, dynamic> map) {
    return AdvisorModel(
      id: map['teacher_id'] ?? 0,
      nip: map['teacher_nip'] ?? '',
      name: map['teacher_name'] ?? '',
      birthDate: map['birth_date'] != null && map['birth_date'] != ''
          ? DateTime.parse(map['birth_date'])
          : DateTime(2000, 1, 1),
      gender: map['teacher_gender'] ?? 0,
      status: map['status'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AdvisorModel.fromJson(String source) =>
      AdvisorModel.fromMap(json.decode(source));
}

extension AdvisorModelX on AdvisorModel {
  AdvisorEntity toEntity() {
    return AdvisorEntity(
      id: id,
      name: name,
      nip: nip,
      birthDate: birthDate,
      gender: gender,
      status: status,
    );
  }

  static AdvisorModel fromEntity(AdvisorEntity entity) {
    return AdvisorModel(
      id: entity.id ?? 0,
      name: entity.name ?? '',
      nip: entity.nip ?? '',
      birthDate: entity.birthDate ?? DateTime.now(),
      gender: entity.gender ?? 0,
      status: entity.status ?? '',
    );
  }
}
