import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherEntity {
  final String nama, mengajar, nip, tanggalLahir, waliKelas, jabatan;
  final int? gender;
  final File? image;
  final String? email, password;
  final bool? isAttendance;
  final Timestamp? timeIn, timeOut;

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
    this.timeIn,
    this.timeOut,
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
    Timestamp? timeIn,
    timeOut,
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
      timeIn: timeIn ?? this.timeIn,
      timeOut: timeOut ?? this.timeOut,
    );
  }
}
