import 'dart:convert';

import 'package:new_sistem_informasi_smanda/data/models/schedule/day.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/schedule/schedule.dart';

class ScheduleModel {
  final String kelas;
  int? order;
  int? degree;
  final Map<String, List<DayModel>> hari;

  ScheduleModel({
    required this.kelas,
    required this.hari,
    this.degree,
    this.order,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "kelas": kelas,
      "degree": degree,
      "order": order,
      ...hari.map(
        (key, value) => MapEntry(key, value.map((e) => e.toMap()).toList()),
      )
    };
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    final hariKeys = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"];
    final parsedHari = <String, List<DayModel>>{};

    for (final key in hariKeys) {
      final data = map[key] as List<dynamic>? ?? [];
      parsedHari[key] = data.map((e) => DayModel.fromMap(e)).toList();
    }

    return ScheduleModel(
      kelas: map["kelas"] as String,
      degree: map["degree"] as int,
      order: map["order"] as int,
      hari: parsedHari,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScheduleModel.fromJson(String source) =>
      ScheduleModel.fromMap(json.decode(source));
}

extension ScheduleXModel on ScheduleModel {
  ScheduleEntity toEntity() {
    return ScheduleEntity(
      kelas: kelas,
      degree: degree,
      order: order,
      hari: hari.map(
        (key, value) => MapEntry(key, value.map((e) => e.toEntity()).toList()),
      ),
    );
  }
}

extension ScheduleXEntity on ScheduleEntity {
  ScheduleModel fromEntity() {
    return ScheduleModel(
      kelas: kelas,
      degree: degree,
      order: order,
      hari: hari.map(
        (key, value) =>
            MapEntry(key, value.map((e) => e.fromEntity()).toList()),
      ),
    );
  }
}
