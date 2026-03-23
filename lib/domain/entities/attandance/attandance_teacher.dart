class AttandanceTeacherEntity {
  int? id, teacherId, gender, total;
  String? name, nip, status;
  DateTime? date, checkIn, checkOut;

  AttandanceTeacherEntity({
    this.checkIn,
    this.checkOut,
    this.date,
    this.gender,
    this.id,
    this.name,
    this.nip,
    this.status,
    this.teacherId,
    this.total,
  });

  AttandanceTeacherEntity copyWith({
    int? id,
    int? teacherId,
    int? gender,
    int? total,
    String? name,
    String? nip,
    String? status,
    DateTime? date,
    DateTime? checkIn,
    DateTime? checkOut,
  }) {
    return AttandanceTeacherEntity(
      gender: gender ?? this.gender,
      status: status ?? this.status,
      checkOut: checkOut ?? this.checkOut,
      checkIn: checkIn ?? this.checkIn,
      date: date ?? this.date,
      id: id ?? this.id,
      name: name ?? this.name,
      nip: nip ?? this.nip,
      teacherId: teacherId ?? this.teacherId,
      total: total ?? this.total,
    );
  }
}
