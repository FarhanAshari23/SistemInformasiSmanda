import '../../../domain/entities/ekskul/anggota.dart';

class AnggotaModel extends AnggotaEntity {
  const AnggotaModel({
    required super.nama,
    required super.nisn,
  });

  factory AnggotaModel.fromMap(Map<String, dynamic> map) {
    return AnggotaModel(
      nama: map['nama'] ?? '',
      nisn: map['nisn'] ?? '',
    );
  }

  factory AnggotaModel.fromEntity(AnggotaEntity entity) {
    return AnggotaModel(
      nama: entity.nama,
      nisn: entity.nisn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'nisn': nisn,
    };
  }

  AnggotaEntity toEntity() => AnggotaEntity(nama: nama, nisn: nisn);
}
