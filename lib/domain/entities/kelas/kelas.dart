class KelasEntity {
  final int? id, totalStudent;
  final int teacherId, sequence, degree;
  final String className, teacherName, teacherNip;

  KelasEntity({
    required this.className,
    this.id,
    required this.teacherId,
    required this.sequence,
    required this.totalStudent,
    required this.teacherName,
    required this.teacherNip,
    required this.degree,
  });
}
