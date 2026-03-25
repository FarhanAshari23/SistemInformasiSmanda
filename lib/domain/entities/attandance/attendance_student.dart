class AttendanceStudentEntity {
  int? id, studentId, tingkat, gender, total;
  String? name, nisn, className, status, religion;
  DateTime? date, checkIn;
  AttendanceStudentEntity({
    this.gender,
    this.status,
    this.checkIn,
    this.className,
    this.date,
    this.id,
    this.name,
    this.nisn,
    this.studentId,
    this.tingkat,
    this.total,
    this.religion,
  });

  AttendanceStudentEntity copyWith({
    int? id,
    int? studentId,
    int? tingkat,
    int? gender,
    int? total,
    String? name,
    String? nisn,
    String? className,
    String? status,
    String? religion,
    DateTime? date,
    DateTime? checkIn,
  }) {
    return AttendanceStudentEntity(
      gender: gender ?? this.gender,
      status: status ?? this.status,
      checkIn: checkIn ?? this.checkIn,
      className: className ?? this.className,
      date: date ?? this.date,
      id: id ?? this.id,
      name: name ?? this.name,
      nisn: nisn ?? this.nisn,
      studentId: studentId ?? this.studentId,
      tingkat: tingkat ?? this.tingkat,
      total: total ?? this.total,
      religion: religion ?? this.religion,
    );
  }
}
