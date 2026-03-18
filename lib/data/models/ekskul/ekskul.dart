import 'dart:convert';

import '../../../domain/entities/ekskul/advisor.dart';
import '../../../domain/entities/ekskul/ekskul.dart';
import 'advisor.dart';
import 'member.dart';

class EkskulModel {
  final int id;
  final String name, description;
  final AdvisorModel advisor;
  final List<MemberModel> members;

  EkskulModel({
    required this.advisor,
    required this.description,
    required this.id,
    required this.members,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'advisor': advisor.toMap(),
      'memberships': members.map((x) => x.toMap()).toList(),
    };
  }

  Map<String, dynamic> createReq() {
    return {
      'name': name,
      'description': description,
      'advisor': advisor.createMap(),
      'memberships': members.map((x) => x.createMap()).toList(),
    };
  }

  factory EkskulModel.fromMap(Map<String, dynamic> map) {
    return EkskulModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      advisor: AdvisorModel.fromMap(map['advisor'] ?? {}),
      members: map['memberships'] != null
          ? List<MemberModel>.from(
              map['memberships'].map((x) => MemberModel.fromMap(x)))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory EkskulModel.fromJson(String source) =>
      EkskulModel.fromMap(json.decode(source));
}

extension EkskulModelX on EkskulModel {
  EkskulEntity toEntity() {
    return EkskulEntity(
      nameEkskul: name,
      description: description,
      advisor: advisor.toEntity(),
      members: members.map((e) => e.toEntity()).toList(),
    );
  }

  static EkskulModel fromEntity(EkskulEntity entity) {
    return EkskulModel(
      id: 0, // Entity biasanya tidak membawa ID saat dari UI ke Model
      name: entity.nameEkskul ?? '',
      description: entity.description ?? '',
      advisor: AdvisorModelX.fromEntity(entity.advisor ?? AdvisorEntity()),
      members:
          entity.members?.map((e) => MemberModelX.fromEntity(e)).toList() ?? [],
    );
  }
}
