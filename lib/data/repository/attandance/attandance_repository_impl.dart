import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/data/models/attendance/attendance.dart';
import 'package:new_sistem_informasi_smanda/data/models/teacher/teacher.dart';
import 'package:new_sistem_informasi_smanda/data/sources/attandance/attandance_firebase_service.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/attandance/param_attendance_teacher.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/attandance/param_delete_attendance.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/teacher/teacher.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/attandance/attandance.dart';

import '../../../domain/entities/attandance/param_attendance.dart';
import '../../../service_locator.dart';
import '../../models/auth/user.dart';

class AttandanceRepositoryImpl extends AttandanceRepository {
  @override
  Future<Either> addStudentAttendances(UserEntity userAddReq) async {
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
                (e) => UserModel.fromMap(e).toEntity(),
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
                (e) => UserModel.fromMap(e).toEntity(),
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
  Future<Either> getAttendanceStudent(UserEntity attendanceReq) async {
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
}
