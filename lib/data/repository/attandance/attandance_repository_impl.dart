import 'package:dartz/dartz.dart';

import '../../../domain/entities/attandance/attandance_teacher.dart';
import '../../../domain/entities/attandance/attendance_student.dart';
import '../../../domain/entities/attandance/attendance_workbook.dart';
import '../../../domain/repository/attandance/attandance.dart';
import '../../../service_locator.dart';
import '../../models/attendance/attendance_student.dart';
import '../../models/attendance/attendance_teacher.dart';
import '../../sources/attandance/attandance_firebase_service.dart';

class AttandanceRepositoryImpl extends AttandanceRepository {
  @override
  Future<Either> addStudentAttendances(AttendanceStudentEntity student) async {
    return await sl<AttandanceFirebaseService>().addStudentAttendances(student);
  }

  @override
  Future<Either> getAttendanceStudents(
      AttendanceStudentEntity attendanceReq) async {
    var returnedData = await sl<AttandanceFirebaseService>()
        .getAttendanceStudents(attendanceReq);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map(
                (e) => AttendanceStudentModel.fromMap(e).toEntity(),
              )
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> searchStudentAttendance(AttendanceStudentEntity req) async {
    var returnedData =
        await sl<AttandanceFirebaseService>().searchStudentAttendance(req);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map(
                (e) => AttendanceStudentModel.fromMap(e).toEntity(),
              )
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> addTeacherAttendances(AttandanceTeacherEntity teacher) async {
    return await sl<AttandanceFirebaseService>().addTeacherAttendances(teacher);
  }

  @override
  Future<Either> getAttendanceTeacher(int teacherId) async {
    var returnedData =
        await sl<AttandanceFirebaseService>().getAttendanceTeacher(teacherId);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map((e) => AttendanceTeacherModel.fromMap(e).toEntity())
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> getAttendanceAllTeacher(AttandanceTeacherEntity req) async {
    var returnedData =
        await sl<AttandanceFirebaseService>().getAttendanceAllTeacher(req);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map(
                (e) => AttendanceTeacherModel.fromMap(e).toEntity(),
              )
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> getAttendanceStudent(int studentId) async {
    var returnedData =
        await sl<AttandanceFirebaseService>().getAttendanceStudent(studentId);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          AttendanceStudentModel.fromMap(data).toEntity(),
        );
      },
    );
  }

  @override
  Future<Either> getListStudentAttendancesDate() async {
    var returnedData =
        await sl<AttandanceFirebaseService>().getListStudentAttendancesDate();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map((e) => AttendanceStudentModel.fromMap(e).toEntity())
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> getListTeacherAttendancesDate() async {
    var returnedData =
        await sl<AttandanceFirebaseService>().getListTeacherAttendancesDate();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map((e) => AttendanceTeacherModel.fromMap(e).toEntity())
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> getListTeacherCompletionsDate() async {
    var returnedData =
        await sl<AttandanceFirebaseService>().getListTeacherCompletionsDate();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map((e) => AttendanceTeacherModel.fromMap(e).toEntity())
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> downloadAttendanceTeachers(
      AttendanceWorkBookEntity req) async {
    return await sl<AttandanceFirebaseService>()
        .downloadAttendanceTeachers(req);
  }

  @override
  Future<Either> addTeacherCompletion(int teacherId) async {
    return await sl<AttandanceFirebaseService>()
        .addTeacherCompletion(teacherId);
  }
}
