import 'dart:convert';

import 'package:new_sistem_informasi_smanda/domain/entities/ekskul/ekskul.dart';

class EkskulModel {
  final String namaEkskul;
  final String namaPembina;
  final String namaKetua;
  final String namaWakilKetua;
  final String namaSekretaris;
  final String namaBendahara;
  final String deskripsi;

  EkskulModel({
    required this.namaEkskul,
    required this.namaPembina,
    required this.namaKetua,
    required this.namaWakilKetua,
    required this.namaSekretaris,
    required this.namaBendahara,
    required this.deskripsi,
  });

  Map<String, dynamic> toMap() {
    return {
      'nama_ekskul': namaEkskul,
      'nama_pembina': namaPembina,
      'nama_ketua': namaKetua,
      'nama_wakil': namaWakilKetua,
      'nama_sekretaris': namaSekretaris,
      'nama_bendahara': namaBendahara,
      'deskripsi': deskripsi,
    };
  }

  factory EkskulModel.fromMap(Map<String, dynamic> map) {
    return EkskulModel(
      namaEkskul: map['nama_ekskul'] ?? '',
      namaPembina: map["nama_pembina"] ?? '',
      namaKetua: map["nama_ketua"] ?? '',
      namaWakilKetua: map["nama_wakil"] ?? '',
      namaSekretaris: map["nama_sekretaris"] ?? '',
      namaBendahara: map["nama_bendahara"] ?? '',
      deskripsi: map["deskripsi"] ?? '',
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
      namaPembina: namaPembina,
      namaKetua: namaKetua,
      namaWakilKetua: namaWakilKetua,
      namaSekretaris: namaSekretaris,
      namaBendahara: namaBendahara,
      deskripsi: deskripsi,
    );
  }
}
