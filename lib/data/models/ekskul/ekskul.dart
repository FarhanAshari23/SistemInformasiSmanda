import 'dart:convert';

import 'package:new_sistem_informasi_smanda/domain/entities/ekskul/ekskul.dart';

import '../auth/user.dart';
import '../teacher/teacher.dart';

class EkskulModel {
  final String namaEkskul;
  final TeacherModel pembina;
  final UserModel ketua;
  final UserModel wakilKetua;
  final UserModel sekretaris;
  final UserModel bendahara;
  final String deskripsi;
  final List<UserModel> anggota;

  EkskulModel({
    required this.namaEkskul,
    required this.pembina,
    required this.ketua,
    required this.wakilKetua,
    required this.sekretaris,
    required this.bendahara,
    required this.deskripsi,
    required this.anggota,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama_ekskul': namaEkskul,
      'pembina': pembina.toMap(),
      'ketua': ketua.toMap(),
      'wakil_ketua': wakilKetua.toMap(),
      'sekretaris': sekretaris.toMap(),
      'bendahara': bendahara.toMap(),
      'deskripsi': deskripsi,
      'anggota': anggota.map((x) => x.toMap()).toList(),
    };
  }

  factory EkskulModel.fromMap(Map<String, dynamic> map) {
    return EkskulModel(
      namaEkskul: map['nama_ekskul'] ?? '',
      pembina: TeacherModel.fromMap(map['pembina']),
      ketua: UserModel.fromMap(map['ketua']),
      wakilKetua: UserModel.fromMap(map['wakil_ketua']),
      sekretaris: UserModel.fromMap(map['sekretaris']),
      bendahara: UserModel.fromMap(map['bendahara']),
      deskripsi: map['deskripsi'] ?? '',
      anggota: map['anggota'] != null
          ? List<UserModel>.from(
              (map['anggota'] as List).map((x) => UserModel.fromMap(x)),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory EkskulModel.fromJson(String source) =>
      EkskulModel.fromMap(json.decode(source));
}

extension EkskulModelX on EkskulModel {
  EkskulEntity toEntity() {
    return EkskulEntity(
      namaEkskul: namaEkskul,
      pembina: pembina.toEntity(),
      ketua: ketua.toEntity(),
      wakilKetua: wakilKetua.toEntity(),
      sekretaris: sekretaris.toEntity(),
      bendahara: bendahara.toEntity(),
      deskripsi: deskripsi,
      anggota: anggota.map((e) => e.toEntity()).toList(),
    );
  }
}
