import 'package:dartz/dartz.dart';

import '../../entities/teacher/role.dart';
import '../../entities/teacher/teacher.dart';

abstract class TeacherRepository {
  Future<Either> createTeacher(TeacherEntity teacherCreationReq);
  Future<Either> updateTeacher(TeacherEntity teacherReq);
  Future<Either> deleteTeacher(int teacherId);
  Future<Either> getTeacherByName(String name);
  Future<Either> getTeacherById(int teacherId);
  Future<Either> getScheduleTeacher(String name);
  Future<Either> getTeacher();
  Future<Either> getRoles();
  Future<Either> createRoles(String role);
  Future<Either> updateRoles(RoleEntity role);
  Future<Either> deleteRole(int idRole);
}
