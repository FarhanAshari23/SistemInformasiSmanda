import 'dart:convert';

import 'package:new_sistem_informasi_smanda/data/models/schedule/day.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/schedule/schedule.dart';

class ScheduleModel {
  final String kelas;
  final List<DayModel> hariSenin;
  final List<DayModel> hariSelasa;
  final List<DayModel> hariRabu;
  final List<DayModel> hariKamis;
  final List<DayModel> hariJumat;

  ScheduleModel({
    required this.kelas,
    required this.hariSenin,
    required this.hariSelasa,
    required this.hariRabu,
    required this.hariKamis,
    required this.hariJumat,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "kelas": kelas,
      "Senin": hariSenin.map((e) => e.toMap()).toList(),
      'Selasa': hariSelasa.map((e) => e.toMap()).toList(),
      'Rabu': hariRabu.map((e) => e.toMap()).toList(),
      'Kamis': hariKamis.map((e) => e.toMap()).toList(),
      'Jumat': hariJumat.map((e) => e.toMap()).toList(),
    };
  }

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      kelas: map['kelas'] as String,
      hariSenin: List<DayModel>.from(
        map['Senin'].map(
          (e) => DayModel.fromMap(e),
        ),
      ),
      hariSelasa: List<DayModel>.from(
        map['Selasa'].map(
          (e) => DayModel.fromMap(e),
        ),
      ),
      hariRabu: List<DayModel>.from(
        map['Rabu'].map(
          (e) => DayModel.fromMap(e),
        ),
      ),
      hariKamis: List<DayModel>.from(
        map['Kamis'].map(
          (e) => DayModel.fromMap(e),
        ),
      ),
      hariJumat: List<DayModel>.from(
        map['Jumat'].map(
          (e) => DayModel.fromMap(e),
        ),
      ),
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
      hariSenin: hariSenin.map((e) => e.toEntity()).toList(),
      hariSelasa: hariSelasa.map((e) => e.toEntity()).toList(),
      hariRabu: hariRabu.map((e) => e.toEntity()).toList(),
      hariKamis: hariKamis.map((e) => e.toEntity()).toList(),
      hariJumat: hariJumat.map((e) => e.toEntity()).toList(),
    );
  }
}

extension ScheduleXEntity on ScheduleEntity {
  ScheduleModel fromEntity() {
    return ScheduleModel(
      kelas: kelas,
      hariSenin: hariSenin.map((e) => e.fromEntity()).toList(),
      hariSelasa: hariSelasa.map((e) => e.fromEntity()).toList(),
      hariRabu: hariRabu.map((e) => e.fromEntity()).toList(),
      hariKamis: hariKamis.map((e) => e.fromEntity()).toList(),
      hariJumat: hariJumat.map((e) => e.fromEntity()).toList(),
    );
  }
}
