class MemberEntity {
  int? id, gender;
  String? name, nisn, role, religion, ekskulName;
  MemberEntity({
    this.id,
    this.role,
    this.name,
    this.nisn,
    this.gender,
    this.religion,
    this.ekskulName,
  });

  MemberEntity copyWith({
    int? id,
    int? gender,
    String? name,
    String? nisn,
    String? role,
    String? religion,
    String? ekskulName,
  }) {
    return MemberEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      nisn: nisn ?? this.nisn,
      role: role ?? this.role,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      ekskulName: ekskulName ?? this.ekskulName,
    );
  }
}
