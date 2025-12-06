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
  final bool? isAttendance;

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
    this.isAttendance,
  });

  TeacherEntity copyWith({
    String? nama,
    String? mengajar,
    String? nip,
    String? tanggalLahir,
    String? waliKelas,
    String? jabatan,
    int? gender,
    File? image,
    String? email,
    String? password,
    bool? isAttendance,
  }) {
    return TeacherEntity(
      nama: nama ?? this.nama,
      mengajar: mengajar ?? this.mengajar,
      nip: nip ?? this.nip,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      waliKelas: waliKelas ?? this.waliKelas,
      jabatan: jabatan ?? this.jabatan,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      password: password ?? this.password,
      image: image ?? this.image,
      isAttendance: isAttendance ?? this.isAttendance,
    );
  }
}
