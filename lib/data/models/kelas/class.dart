import 'dart:convert';

import 'package:new_sistem_informasi_smanda/domain/entities/kelas/kelas.dart';

class KelasModel {
  final String kelas;
  final int order;
  final int degree;

  KelasModel({
    required this.kelas,
    required this.order,
    required this.degree,
  });

  Map<String, dynamic> toMap() {
    return {
      'class': kelas,
      'order': order,
      'degree': degree,
    };
  }

  factory KelasModel.fromMap(Map<String, dynamic> map) {
    return KelasModel(
      kelas: map['class'],
      order: map['order'],
      degree: map['degree'],
    );
  }

  String toJson() => json.encode(toMap());

  factory KelasModel.fromJson(String source) =>
      KelasModel.fromMap(json.decode(source));
}

extension KelasModelX on KelasModel {
  KelasEntity toEntity() {
    return KelasEntity(
      kelas: kelas,
      order: order,
      degree: degree,
    );
  }
}
