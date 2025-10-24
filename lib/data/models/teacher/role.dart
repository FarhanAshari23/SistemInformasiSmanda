import 'dart:convert';

import '../../../domain/entities/schedule/role.dart';

class RoleModel {
  final String name;

  RoleModel({required this.name});

  Map<String, dynamic> toMap() {
    return {
      'role': name,
    };
  }

  factory RoleModel.fromMap(Map<String, dynamic> map) {
    return RoleModel(
      name: map["role"] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RoleModel.fromJson(String source) =>
      RoleModel.fromMap(json.decode(source));
}

extension RoleModelX on RoleModel {
  RoleEntity toEntity() {
    return RoleEntity(name: name);
  }
}
