class AdvisorEntity {
  int? id, gender;
  String? name, nip, status, picture;
  DateTime? birthDate;
  AdvisorEntity({
    this.id,
    this.nip,
    this.name,
    this.birthDate,
    this.gender,
    this.status,
    this.picture,
  });

  AdvisorEntity copyWith({
    int? id,
    int? gender,
    String? name,
    String? nip,
    String? status,
    String? picture,
    DateTime? birthDate,
  }) {
    return AdvisorEntity(
        id: id ?? this.id,
        nip: nip ?? this.nip,
        name: name ?? this.name,
        birthDate: birthDate ?? this.birthDate,
        gender: gender ?? this.gender,
        status: status ?? this.status,
        picture: picture ?? this.picture);
  }
}
