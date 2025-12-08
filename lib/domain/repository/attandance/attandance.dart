import 'package:dartz/dartz.dart';
import '../../entities/attandance/param_attendance.dart';
import '../../entities/attandance/param_attendance_teacher.dart';
import '../../entities/attandance/param_delete_attendance.dart';
import '../../entities/auth/user.dart';
import '../../entities/teacher/teacher.dart';

abstract class AttandanceRepository {
  Future<Either> getListAttendanceDate(String nameCollection);
  Future<Either> deleteAllAttendances();
  Future<Either> deleteMonthAttendances(ParamDeleteAttendance attendanceReq);
  Future<Either> searchStudentAttendance(ParamAttendanceEntity attendanceReq);
  Future<Either> getAttendanceStudents(ParamAttendanceEntity attendanceReq);
  Future<Either> getAttendanceTeacher(TeacherEntity attendanceReq);
  Future<Either> getAttendanceAllTeacher(ParamAttendanceTeacher req);
  Future<Either> addStudentAttendances(UserEntity userAddReq);
  Future<Either> addTeacherAttendances(TeacherEntity teacherAddReq);
}
