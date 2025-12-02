import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/attandance/param_attendance.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/attandance/param_delete_attendance.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';

abstract class AttandanceRepository {
  Future<Either> getListAttendanceDate();
  Future<Either> deleteAllAttendances();
  Future<Either> deleteMonthAttendances(ParamDeleteAttendance attendanceReq);
  Future<Either> searchStudentAttendance(ParamAttendanceEntity attendanceReq);
  Future<Either> getAttendanceStudents(ParamAttendanceEntity attendanceReq);
  Future<Either> addStudentAttendances(UserEntity userAddReq);
}
