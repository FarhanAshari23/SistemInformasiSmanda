import 'dart:convert';

import '../../../domain/entities/ekskul/ekskul.dart';
import 'advisor.dart';
import 'member.dart';

class EkskulModel {
  final int id;
  final String name, description;
  final List<AdvisorModel> advisors;
  final List<MemberModel> members;

  EkskulModel({
    required this.advisors,
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
      'advisor': advisors.map((x) => x.toMap()).toList(),
      'memberships': members.map((x) => x.toMap()).toList(),
    };
  }

  Map<String, dynamic> createReq() {
    return {
      'name': name,
      'description': description,
      'advisor': advisors.map((x) => x.createMap()).toList(),
      'memberships': members.map((x) => x.createMap()).toList(),
    };
  }

  Map<String, dynamic> updateReq() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'advisor': advisors.map((x) => x.createMap()).toList(),
      'memberships': members.map((x) => x.createMap()).toList(),
    };
  }

  factory EkskulModel.fromMap(Map<String, dynamic> map) {
    return EkskulModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      advisors: map['advisor'] != null
          ? List<AdvisorModel>.from(
              map['advisor'].map((x) => AdvisorModel.fromMap(x)))
          : [],
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
      id: id,
      nameEkskul: name,
      description: description,
      advisors: advisors.map((e) => e.toEntity()).toList(),
      members: members.map((e) => e.toEntity()).toList(),
    );
  }

  static EkskulModel fromEntity(EkskulEntity entity) {
    return EkskulModel(
      id: entity.id ?? 0,
      name: entity.nameEkskul ?? '',
      description: entity.description ?? '',
      advisors:
          entity.advisors?.map((e) => AdvisorModelX.fromEntity(e)).toList() ??
              [],
      members:
          entity.members?.map((e) => MemberModelX.fromEntity(e)).toList() ?? [],
    );
  }
}
