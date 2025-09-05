import 'package:new_sistem_informasi_smanda/domain/entities/schedule/day.dart';

class ScheduleEntity {
  final String kelas;
  final int order;
  final int degree;
  final Map<String, List<DayEntity>> hari;

  ScheduleEntity({
    required this.kelas,
    required this.degree,
    required this.order,
    required this.hari,
  });
}
