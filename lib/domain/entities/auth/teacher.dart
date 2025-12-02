import 'dart:io';

class TeacherEntity {
  final String nama;
  final String mengajar;
  final String nip;
  final String tanggalLahir;
  final String waliKelas;
  final String jabatan;
  final int? gender;
  final File? image;
  final String? email;
  final String? password;

  TeacherEntity({
    required this.nama,
    required this.mengajar,
    required this.nip,
    required this.tanggalLahir,
    required this.waliKelas,
    required this.jabatan,
    required this.gender,
    this.email,
    this.password,
    this.image,
  });
}
