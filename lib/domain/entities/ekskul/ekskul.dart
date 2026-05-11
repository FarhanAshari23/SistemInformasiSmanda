import 'dart:io';

import 'advisor.dart';
import 'member.dart';

class EkskulEntity {
  int? id;
  String? nameEkskul, description, picture;
  File? imageFile;
  List<AdvisorEntity>? advisors;
  List<MemberEntity>? members;

  EkskulEntity({
    this.id,
    this.advisors,
    this.description,
    this.members,
    this.nameEkskul,
    this.picture,
    this.imageFile,
  });

  EkskulEntity copyWith({
    int? id,
    String? nameEkskul,
    String? description,
    String? picture,
    File? imageFile,
    List<AdvisorEntity>? advisors,
    List<MemberEntity>? members,
  }) {
    return EkskulEntity(
      id: id ?? this.id,
      description: description ?? this.description,
      nameEkskul: nameEkskul ?? this.nameEkskul,
      advisors: advisors ?? this.advisors,
      members: members ?? this.members,
      imageFile: imageFile ?? this.imageFile,
      picture: picture ?? this.picture,
    );
  }
}
