import '../schedule/day.dart';

class KelasEntity {
  int? id, totalStudent, teacherId, sequence, degree;
  String? className, teacherName, teacherNip;
  List<DayEntity>? schedules;

  KelasEntity({
    this.className,
    this.id,
    this.teacherId,
    this.sequence,
    this.totalStudent,
    this.teacherName,
    this.teacherNip,
    this.degree,
    this.schedules,
  });

  KelasEntity copyWith({
    int? id,
    int? totalStudent,
    int? teacherId,
    int? sequence,
    int? degree,
    String? className,
    String? teacherName,
    String? teacherNip,
    List<DayEntity>? schedules,
  }) {
    return KelasEntity(
      className: className ?? this.className,
      degree: degree ?? this.degree,
      id: id ?? this.id,
      sequence: sequence ?? this.sequence,
      teacherId: teacherId ?? this.teacherId,
      teacherName: teacherName ?? this.teacherName,
      teacherNip: teacherNip ?? this.teacherNip,
      totalStudent: totalStudent ?? this.totalStudent,
      schedules: schedules ?? this.schedules,
    );
  }
}
