import 'dart:convert';

import '../../../domain/entities/student/student.dart';

class StudentModel {
  final int id;
  final String nisn;
  final String name;
  final int kelasId;
  final String nameClass;
  final String religion;
  final String address;
  final String mobileNum;
  final int gender;
  final DateTime birthDate;
  final String email;
  final dynamic password;
  final bool isRegister;
  final bool isAdmin;
  final dynamic iv;

  StudentModel({
    required this.id,
    required this.nisn,
    required this.name,
    required this.kelasId,
    required this.nameClass,
    required this.religion,
    required this.address,
    required this.mobileNum,
    required this.gender,
    required this.birthDate,
    required this.password,
    required this.email,
    required this.isRegister,
    required this.isAdmin,
    required this.iv,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'id': id,
      'nisn': nisn,
      'name': name,
      'kelas_id': kelasId,
      'name_class': nameClass,
      'religion': religion,
      'address': address,
      'mobile_num': mobileNum,
      'gender': gender,
      'birth_date': birthDate.toUtc().toIso8601String(),
      'email': email,
      'password': password,
      'is_register': isRegister,
      'is_admin': isAdmin,
      'iv': iv,
    };

    data.removeWhere((key, value) {
      if (value == null) return true;
      if (value == 0) return true;
      if (value is String && value.isEmpty) return true;
      return false;
    });

    return data;
  }

  Map<String, dynamic> updateStudent() {
    return {
      'nisn': nisn,
      'name': name,
      'kelas_id': kelasId,
      'religion': religion,
      'address': address,
      'mobile_num': mobileNum,
      'gender': gender,
      'birth_date': birthDate.toUtc().toIso8601String(),
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> map) {
    return StudentModel(
      id: map['id'] ?? 0,
      nisn: map['nisn'] ?? '',
      name: map['name'] ?? '',
      kelasId: map['kelas_id'] ?? 0,
      nameClass: map['name_class'] ?? '',
      religion: map['religion'] ?? '',
      address: map['address'] ?? '',
      mobileNum: map['mobile_num'] ?? '',
      gender: map['gender'] ?? 0,
      birthDate: map['birth_date'] != null && map['birth_date'] != ''
          ? DateTime.parse(map['birth_date'])
          : DateTime(2000, 1, 1),
      email: map['email'] ?? '',
      password: map['password'],
      isRegister: map['is_register'] ?? false,
      isAdmin: map['is_admin'] ?? false,
      iv: map['iv'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentModel.fromJson(String source) =>
      StudentModel.fromMap(json.decode(source));
}

extension StudentModelX on StudentModel {
  StudentEntity toEntity() {
    return StudentEntity(
      address: address,
      birthDate: birthDate,
      gender: gender,
      id: id,
      isAdmin: isAdmin,
      isRegister: isRegister,
      iv: iv,
      kelasId: kelasId,
      mobileNum: mobileNum,
      name: name,
      nameClass: nameClass,
      nisn: nisn,
      password: password,
      religion: religion,
    );
  }

  static StudentModel fromEntity(StudentEntity entity) {
    return StudentModel(
      address: entity.address ?? '',
      birthDate: entity.birthDate ?? DateTime.now(),
      email: entity.email ?? '',
      gender: entity.gender ?? 0,
      id: entity.id ?? 0,
      isAdmin: entity.isAdmin ?? false,
      isRegister: entity.isRegister ?? false,
      iv: entity.iv ?? '',
      kelasId: entity.kelasId ?? 0,
      mobileNum: entity.mobileNum ?? '',
      name: entity.name ?? '',
      nameClass: entity.nameClass ?? '',
      nisn: entity.nisn ?? '',
      password: entity.password ?? '',
      religion: entity.religion ?? '',
    );
  }
}
