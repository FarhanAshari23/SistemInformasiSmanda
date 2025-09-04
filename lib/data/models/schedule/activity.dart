import 'dart:convert';

import 'package:new_sistem_informasi_smanda/domain/entities/schedule/activity.dart';

class ActivityModel {
  final String name;

  ActivityModel({required this.name});

  Map<String, dynamic> toMap() {
    return {
      'kegiatan': name,
    };
  }

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      name: map["kegiatan"] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityModel.fromJson(String source) =>
      ActivityModel.fromMap(json.decode(source));
}

extension ActivityModelX on ActivityModel {
  ActivityEntity toEntity() {
    return ActivityEntity(name: name);
  }
}
