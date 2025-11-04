import 'package:new_sistem_informasi_smanda/domain/entities/schedule/day.dart';

class ScheduleEntity {
  final String kelas;
  final String? oldNamaKelas;
  int? order;
  int? degree;
  final Map<String, List<DayEntity>> hari;

  ScheduleEntity({
    required this.kelas,
    this.degree,
    this.order,
    required this.hari,
    this.oldNamaKelas,
  });
}
