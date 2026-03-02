import 'dart:convert';

import 'package:new_sistem_informasi_smanda/domain/entities/auth/user_golang.dart';

class UserGolangModel {
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

  UserGolangModel({
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

  factory UserGolangModel.fromMap(Map<String, dynamic> map) {
    return UserGolangModel(
      address: map['address'] ?? '',
      birthDate: map['birth_date'] != null && map['birth_date'] != ''
          ? DateTime.parse(map['birth_date'])
          : DateTime(2000, 1, 1),
      email: map['email'] ?? '',
      gender: map['gender'] ?? '',
      id: map['id'] ?? '',
      isAdmin: map['is_admin'] ?? '',
      isRegister: map['is_register'] ?? '',
      iv: map['iv'] ?? '',
      kelasId: map['kelas_id'] ?? '',
      mobileNum: map['mobile_num'] ?? '',
      name: map['name'] ?? '',
      nameClass: map['name_class'] ?? '',
      nisn: map['nisn'] ?? '',
      password: map['password'] ?? '',
      religion: map['religion'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserGolangModel.fromJson(String source) =>
      UserGolangModel.fromMap(json.decode(source));
}

extension UserGolangModelX on UserGolangModel {
  UserGolang toEntity() {
    return UserGolang(
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

  static UserGolangModel fromEntity(UserGolang entity) {
    return UserGolangModel(
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
