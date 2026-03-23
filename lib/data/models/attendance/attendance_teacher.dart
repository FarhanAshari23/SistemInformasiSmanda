import '../../../domain/entities/attandance/attandance_teacher.dart';

class AttendanceTeacherModel {
  final int id;
  final int teacherId;
  final int gender;
  final int total;
  final String name;
  final String nip;
  final String status;
  final DateTime date;
  final DateTime checkIn;
  final DateTime checkOut;

  AttendanceTeacherModel({
    required this.id,
    required this.teacherId,
    required this.gender,
    required this.name,
    required this.nip,
    required this.status,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      "id": id,
      "teacher_id": teacherId,
      "nama_guru": name,
      "nip_guru": nip,
      "gender_guru": gender,
      "attendance_date": date,
      "check_in": checkIn,
      "check_out": checkOut,
      "status": status,
      "total": total,
    };
    data.removeWhere((key, value) {
      if (value == null) return true;
      if (value == 0) return true;
      if (value is Iterable && value.isEmpty) return true;
      if (value is String && value.isEmpty) return true;
      return false;
    });

    return data;
  }

  Map<String, dynamic> createReq() {
    return {
      "status": status,
      "teacher_id": teacherId,
    };
  }

  Map<String, dynamic> updateCheckOut() {
    return {
      "teacher_id": teacherId,
    };
  }

  factory AttendanceTeacherModel.fromMap(Map<String, dynamic> map) {
    return AttendanceTeacherModel(
      id: map['id'] ?? 0,
      nip: map['nip'] ?? '',
      name: map['nama_guru'] ?? '',
      gender: map['gender_guru'] ?? 0,
      date: map['attendance_date'] != null && map['birth_date'] != ''
          ? DateTime.parse(map['birth_date'])
          : DateTime(2000, 1, 1),
      checkIn: map['check_in'] != null && map['check_in'] != ''
          ? DateTime.parse(map['check_in'])
          : DateTime(2000, 1, 1),
      checkOut: map['check_out'] != null && map['check_out'] != ''
          ? DateTime.parse(map['check_out'])
          : DateTime(2000, 1, 1),
      status: map['status'] ?? '',
      teacherId: map['teacher_id'] ?? 0,
      total: map['total_guru'] ?? 0,
    );
  }
}

extension AttendanceTeacherModelX on AttendanceTeacherModel {
  AttandanceTeacherEntity toEntity() {
    return AttandanceTeacherEntity(
      checkIn: checkIn,
      checkOut: checkOut,
      date: date,
      gender: gender,
      id: id,
      name: name,
      nip: nip,
      status: status,
      teacherId: teacherId,
      total: total,
    );
  }

  static AttendanceTeacherModel fromEntity(AttandanceTeacherEntity entity) {
    return AttendanceTeacherModel(
      id: entity.id ?? 0,
      teacherId: entity.teacherId ?? 0,
      gender: entity.gender ?? 0,
      name: entity.name ?? '',
      nip: entity.nip ?? '',
      status: entity.status ?? '',
      date: entity.date ?? DateTime.now(),
      checkIn: entity.checkIn ?? DateTime.now(),
      checkOut: entity.checkOut ?? DateTime.now(),
      total: entity.total ?? 0,
    );
  }
}
