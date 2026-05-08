import 'advisor.dart';
import 'member.dart';

class EkskulEntity {
  int? id;
  String? nameEkskul, description;
  List<AdvisorEntity>? advisors;
  List<MemberEntity>? members;

  EkskulEntity({
    this.id,
    this.advisors,
    this.description,
    this.members,
    this.nameEkskul,
  });

  EkskulEntity copyWith({
    int? id,
    String? nameEkskul,
    String? description,
    List<AdvisorEntity>? advisors,
    List<MemberEntity>? members,
  }) {
    return EkskulEntity(
      id: id ?? this.id,
      description: description ?? this.description,
      nameEkskul: nameEkskul ?? this.nameEkskul,
      advisors: advisors ?? this.advisors,
      members: members ?? this.members,
    );
  }
}
