import 'package:dartz/dartz.dart';

import '../../../domain/entities/attandance/param_attendance.dart';
import '../../../domain/entities/attandance/param_attendance_teacher.dart';
import '../../../domain/entities/attandance/param_delete_attendance.dart';
import '../../../domain/entities/student/student.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/repository/attandance/attandance.dart';
import '../../../service_locator.dart';
import '../../models/attendance/attendance.dart';
import '../../models/student/student.dart';
import '../../models/teacher/teacher.dart';
import '../../sources/attandance/attandance_firebase_service.dart';

class AttandanceRepositoryImpl extends AttandanceRepository {
  @override
  Future<Either> addStudentAttendances(StudentEntity userAddReq) async {
    return await sl<AttandanceFirebaseService>()
        .addStudentAttendances(userAddReq);
  }

  @override
  Future<Either> getAttendanceStudents(
      ParamAttendanceEntity attendanceReq) async {
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
                (e) => StudentModel.fromMap(e).toEntity(),
              )
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> searchStudentAttendance(
      ParamAttendanceEntity attendanceReq) async {
    var returnedData = await sl<AttandanceFirebaseService>()
        .searchStudentAttendance(attendanceReq);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map(
                (e) => StudentModel.fromMap(e).toEntity(),
              )
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> deleteAllAttendances() async {
    return await sl<AttandanceFirebaseService>().deleteAllAttendances();
  }

  @override
  Future<Either> deleteMonthAttendances(
      ParamDeleteAttendance attendanceReq) async {
    return await sl<AttandanceFirebaseService>()
        .deleteMonthAttendances(attendanceReq);
  }

  @override
  Future<Either> addTeacherAttendances(TeacherEntity teacherAddReq) async {
    return await sl<AttandanceFirebaseService>()
        .addTeacherAttendances(teacherAddReq);
  }

  @override
  Future<Either> getAttendanceTeacher(TeacherEntity attendanceReq) async {
    var returnedData = await sl<AttandanceFirebaseService>()
        .getAttendanceTeacher(attendanceReq);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map((e) => AttendanceModel.fromMap(e).toEntity())
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> getAttendanceAllTeacher(ParamAttendanceTeacher req) async {
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
                (e) => TeacherModel.fromMap(e).toEntity(),
              )
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> getAttendanceStudent(StudentEntity attendanceReq) async {
    var returnedData = await sl<AttandanceFirebaseService>()
        .getAttendanceStudent(attendanceReq);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map((e) => AttendanceModel.fromMap(e).toEntity())
              .toList(),
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
              .map((e) => AttendanceModel.fromMap(e).toEntity())
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
              .map((e) => AttendanceModel.fromMap(e).toEntity())
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
              .map((e) => AttendanceModel.fromMap(e).toEntity())
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> downloadAttendanceTeachers(ParamAttendanceTeacher req) async {
    return await sl<AttandanceFirebaseService>()
        .downloadAttendanceTeachers(req);
  }
}
