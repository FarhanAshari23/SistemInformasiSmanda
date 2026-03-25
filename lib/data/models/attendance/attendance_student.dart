import '../../../domain/entities/attandance/attendance_student.dart';

class AttendanceStudentModel {
  final int id;
  final int studentId;
  final int tingkat;
  final int gender;
  final int total;
  final String name;
  final String nisn;
  final String className;
  final String status;
  final DateTime date;
  final DateTime checkIn;
  final String religion;

  AttendanceStudentModel({
    required this.id,
    required this.studentId,
    required this.tingkat,
    required this.gender,
    required this.name,
    required this.nisn,
    required this.className,
    required this.status,
    required this.date,
    required this.total,
    required this.checkIn,
    required this.religion,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "student_id": studentId,
      "nama_siswa": name,
      "nisn_siswa": nisn,
      "gender_siswa": gender,
      "tingkat": tingkat,
      "kelas_siswa": className,
      "attendance_date": date,
      "check_in": checkIn,
      "status": status,
      "total": total,
      "agama": religion,
    };
  }

  Map<String, dynamic> createReq() {
    return {
      "status": status,
      "student_id": studentId,
    };
  }

  factory AttendanceStudentModel.fromMap(Map<String, dynamic> map) {
    return AttendanceStudentModel(
      id: map['id'] ?? 0,
      nisn: map['nisn_siswa'] ?? '',
      name: map['nama_siswa'] ?? '',
      gender: map['gender_siswa'] ?? 0,
      date: map['attendance_date'] != null && map['attendance_date'] != ''
          ? DateTime.parse(map['attendance_date'])
          : DateTime(2000, 1, 1),
      checkIn: map['check_in'] != null && map['check_in'] != ''
          ? DateTime.parse(map['check_in'])
          : DateTime(2000, 1, 1),
      status: map['status'] ?? '',
      studentId: map['student_id'] ?? 0,
      className: map['kelas_siswa'] ?? '',
      religion: map['agama'] ?? '',
      tingkat: map['tingkat'] ?? 0,
      total: map['total'] ?? 0,
    );
  }
}

extension AttendanceStudentModelX on AttendanceStudentModel {
  AttendanceStudentEntity toEntity() {
    return AttendanceStudentEntity(
      checkIn: checkIn,
      date: date,
      gender: gender,
      id: id,
      name: name,
      nisn: nisn,
      status: status,
      className: className,
      studentId: studentId,
      tingkat: tingkat,
      total: total,
      religion: religion,
    );
  }

  static AttendanceStudentModel fromEntity(AttendanceStudentEntity entity) {
    return AttendanceStudentModel(
      id: entity.id ?? 0,
      studentId: entity.studentId ?? 0,
      gender: entity.gender ?? 0,
      name: entity.name ?? '',
      nisn: entity.nisn ?? '',
      status: entity.status ?? '',
      date: entity.date ?? DateTime.now(),
      checkIn: entity.checkIn ?? DateTime.now(),
      className: entity.className ?? '',
      tingkat: entity.tingkat ?? 0,
      total: entity.total ?? 0,
      religion: entity.religion ?? '',
    );
  }
}
