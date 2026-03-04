import 'dart:convert';

import 'package:new_sistem_informasi_smanda/domain/entities/schedule/activity.dart';

class ActivityModel {
  final String name;
  final int id;

  ActivityModel({
    required this.name,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      name: map["name"] ?? '',
      id: map["id"] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityModel.fromJson(String source) =>
      ActivityModel.fromMap(json.decode(source));
}

extension ActivityModelX on ActivityModel {
  ActivityEntity toEntity() {
    return ActivityEntity(
      name: name,
      id: id,
    );
  }
}
