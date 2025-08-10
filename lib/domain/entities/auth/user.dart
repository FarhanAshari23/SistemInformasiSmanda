import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
  String? email;
  String? nama;
  String? kelas;
  String? nisn;
  String? tanggalLahir;
  String? noHP;
  String? alamat;
  String? ekskul;
  int? gender;
  bool? isAdmin;
  String? agama;
  Timestamp? timeIn;

  UserEntity({
    required this.email,
    required this.nama,
    required this.kelas,
    required this.nisn,
    required this.tanggalLahir,
    required this.noHP,
    required this.alamat,
    required this.ekskul,
    required this.gender,
    required this.isAdmin,
    required this.agama,
    this.timeIn,
  });
}
