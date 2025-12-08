import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/teacher/teacher.dart';

class TeacherModel {
  final String nama;
  final String mengajar;
  final String nip;
  final String tanggalLahir;
  final String waliKelas;
  final String jabatan;
  final int? gender;
  final Timestamp? timeIn, timeOut;

  TeacherModel({
    required this.nama,
    required this.mengajar,
    required this.nip,
    required this.tanggalLahir,
    required this.waliKelas,
    required this.jabatan,
    required this.gender,
    this.timeIn,
    this.timeOut,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'mengajar': mengajar,
      'NIP': nip,
      'tanggal_lahir': tanggalLahir,
      'wali_kelas': waliKelas,
      'jabatan_tambahan': jabatan,
      "gender": gender,
      "jam_masuk": timeIn,
      "jam_pulang": timeOut,
    };
  }

  factory TeacherModel.fromMap(Map<String, dynamic> map) {
    return TeacherModel(
        nama: map["nama"] ?? '',
        mengajar: map["mengajar"] ?? '',
        nip: map["NIP"] ?? '',
        tanggalLahir: map["tanggal_lahir"] ?? '',
        waliKelas: map["wali_kelas"] ?? '',
        jabatan: map["jabatan_tambahan"] ?? '',
        gender: map["gender"],
        timeIn: map['jam_masuk'],
        timeOut: map['jam_pulang']);
  }

  String toJson() => json.encode(toMap());

  factory TeacherModel.fromJson(String source) =>
      TeacherModel.fromMap(json.decode(source));
}

extension TeacherModelX on TeacherModel {
  TeacherEntity toEntity() {
    return TeacherEntity(
      nama: nama,
      mengajar: mengajar,
      nip: nip,
      tanggalLahir: tanggalLahir,
      waliKelas: waliKelas,
      jabatan: jabatan,
      gender: gender,
      timeIn: timeIn,
      timeOut: timeOut,
    );
  }

  static TeacherModel fromEntity(TeacherEntity entity) {
    return TeacherModel(
      nama: entity.nama,
      mengajar: entity.mengajar,
      nip: entity.nip,
      tanggalLahir: entity.tanggalLahir,
      waliKelas: entity.waliKelas,
      jabatan: entity.jabatan,
      gender: entity.gender,
      timeIn: entity.timeIn,
      timeOut: entity.timeOut,
    );
  }
}
