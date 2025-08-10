import 'dart:convert';

import 'package:new_sistem_informasi_smanda/domain/entities/schedule/day.dart';

class DayModel {
  final String jam;
  final String kegiatan;
  final String pelaksana;

  DayModel({
    required this.jam,
    required this.kegiatan,
    required this.pelaksana,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Jam': jam,
      'Kegiatan': kegiatan,
      'Pelaksana': pelaksana,
    };
  }

  factory DayModel.fromMap(Map<String, dynamic> map) {
    return DayModel(
      jam: map['Jam'] ?? '',
      kegiatan: map['Kegiatan'] ?? '',
      pelaksana: map['Pelaksana'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DayModel.fromJson(String source) =>
      DayModel.fromMap(json.decode(source));
}

extension DayXModel on DayModel {
  DayEntity toEntity() {
    return DayEntity(
      jam: jam,
      kegiatan: kegiatan,
      pelaksana: pelaksana,
    );
  }
}

extension DayXEntity on DayEntity {
  DayModel fromEntity() {
    return DayModel(
      jam: jam,
      kegiatan: kegiatan,
      pelaksana: pelaksana,
    );
  }
}
