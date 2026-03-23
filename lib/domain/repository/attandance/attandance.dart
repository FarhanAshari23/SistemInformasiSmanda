import 'package:dartz/dartz.dart';
import '../../entities/attandance/attandance_teacher.dart';
import '../../entities/attandance/attendance_student.dart';
import '../../entities/attandance/attendance_workbook.dart';

abstract class AttandanceRepository {
  Future<Either> addStudentAttendances(AttendanceStudentEntity student);
  Future<Either> addTeacherAttendances(AttandanceTeacherEntity teacher);
  Future<Either> getListStudentAttendancesDate();
  Future<Either> getListTeacherAttendancesDate();
  Future<Either> getListTeacherCompletionsDate();
  Future<Either> getAttendanceStudents(AttendanceStudentEntity attendanceReq);
  Future<Either> getAttendanceAllTeacher(AttandanceTeacherEntity req);
  Future<Either> getAttendanceTeacher(int teacherId);
  Future<Either> getAttendanceStudent(int studentId);
  Future<Either> searchStudentAttendance(AttendanceStudentEntity req);
  Future<Either> downloadAttendanceTeachers(AttendanceWorkBookEntity req);
}
