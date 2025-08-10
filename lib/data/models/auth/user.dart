import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/auth/user.dart';

class UserModel {
  final String email;
  final String nama;
  final String kelas;
  final String nisn;
  final String tanggalLahir;
  final String noHp;
  final String alamat;
  final String ekskul;
  final int gender;
  final bool isAdmin;
  final String agama;
  Timestamp? timeIn;

  UserModel({
    required this.email,
    required this.nama,
    required this.kelas,
    required this.nisn,
    required this.tanggalLahir,
    required this.noHp,
    required this.alamat,
    required this.ekskul,
    required this.gender,
    required this.isAdmin,
    required this.agama,
    this.timeIn,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nama': nama,
      'kelas': kelas,
      'nisn': nisn,
      'tanggal_lahir': tanggalLahir,
      'No_HP': noHp,
      'alamat': alamat,
      'ekskul': ekskul,
      'gender': gender,
      'isAdmin': isAdmin,
      'agama': agama,
      'jam_masuk': timeIn,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        email: map['email'] ?? '',
        nama: map['nama'] ?? '',
        kelas: map['kelas'] ?? '',
        nisn: map['nisn'] ?? '',
        tanggalLahir: map['tanggal_lahir'] ?? '',
        noHp: map['No_HP'] ?? '',
        alamat: map['alamat'] ?? '',
        ekskul: map['ekskul'] ?? '',
        gender: map['gender']?.toInt() ?? 0,
        isAdmin: map['isAdmin'] ?? false,
        timeIn: map['jam_masuk'] ?? Timestamp.now(),
        agama: map['agama'] ?? '');
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}

extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      email: email,
      nama: nama,
      kelas: kelas,
      nisn: nisn,
      tanggalLahir: tanggalLahir,
      noHP: noHp,
      alamat: alamat,
      ekskul: ekskul,
      gender: gender,
      isAdmin: isAdmin,
      agama: agama,
      timeIn: timeIn,
    );
  }
}
