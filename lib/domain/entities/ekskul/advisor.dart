class AdvisorEntity {
  int? id, gender;
  String? name, nip, status;
  DateTime? birthDate;
  AdvisorEntity({
    this.id,
    this.nip,
    this.name,
    this.birthDate,
    this.gender,
    this.status,
  });

  AdvisorEntity copyWith({
    int? id,
    int? gender,
    String? name,
    String? nip,
    String? status,
    DateTime? birthDate,
  }) {
    return AdvisorEntity(
      id: id ?? this.id,
      nip: nip ?? this.nip,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      status: status ?? this.status,
    );
  }
}
