import 'dart:convert';

import '../../../domain/entities/teacher/role.dart';

class RoleModel {
  final String name;
  final int id;

  RoleModel({
    required this.name,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory RoleModel.fromMap(Map<String, dynamic> map) {
    return RoleModel(
      name: map["name"] ?? '',
      id: map['id'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RoleModel.fromJson(String source) =>
      RoleModel.fromMap(json.decode(source));
}

extension RoleModelX on RoleModel {
  RoleEntity toEntity() {
    return RoleEntity(
      name: name,
      id: id,
    );
  }
}
