import 'advisor.dart';
import 'member.dart';

class EkskulEntity {
  int? id;
  String? nameEkskul, description;
  AdvisorEntity? advisor;
  List<MemberEntity>? members;

  EkskulEntity({
    this.id,
    this.advisor,
    this.description,
    this.members,
    this.nameEkskul,
  });

  EkskulEntity copyWith({
    int? id,
    String? nameEkskul,
    String? description,
    AdvisorEntity? advisor,
    List<MemberEntity>? members,
  }) {
    return EkskulEntity(
      id: id ?? this.id,
      description: description ?? this.description,
      nameEkskul: nameEkskul ?? this.nameEkskul,
      advisor: advisor ?? this.advisor,
      members: members ?? this.members,
    );
  }
}
