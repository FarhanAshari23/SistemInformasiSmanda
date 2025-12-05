import 'package:dartz/dartz.dart';

import '../../entities/attandance/param_attendance.dart';
import '../../entities/attandance/param_delete_attendance.dart';
import '../../entities/auth/user.dart';
import '../../entities/teacher/teacher.dart';

abstract class AttandanceRepository {
  Future<Either> getListAttendanceDate();
  Future<Either> deleteAllAttendances();
  Future<Either> deleteMonthAttendances(ParamDeleteAttendance attendanceReq);
  Future<Either> searchStudentAttendance(ParamAttendanceEntity attendanceReq);
  Future<Either> getAttendanceStudents(ParamAttendanceEntity attendanceReq);
  Future<Either> addStudentAttendances(UserEntity userAddReq);
  Future<Either> addTeacherAttendances(TeacherEntity teacherAddReq);
  Future<Either> addTeacherCompletion(TeacherEntity teacherAddReq);
}
