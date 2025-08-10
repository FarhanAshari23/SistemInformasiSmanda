import 'package:new_sistem_informasi_smanda/domain/entities/schedule/day.dart';

class ScheduleEntity {
  final String kelas;
  final List<DayEntity> hariSenin;
  final List<DayEntity> hariSelasa;
  final List<DayEntity> hariRabu;
  final List<DayEntity> hariKamis;
  final List<DayEntity> hariJumat;

  ScheduleEntity({
    required this.kelas,
    required this.hariSenin,
    required this.hariSelasa,
    required this.hariRabu,
    required this.hariKamis,
    required this.hariJumat,
  });
}
