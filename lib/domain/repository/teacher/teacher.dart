import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/teacher/teacher.dart';

import '../../entities/teacher/role.dart';
import '../../entities/teacher/teacher_golang.dart';

abstract class TeacherRepository {
  Future<Either> createTeacher(TeacherGolangEntity teacherCreationReq);
  Future<Either> updateTeacher(TeacherEntity teacherReq);
  Future<Either> deleteTeacher(int teacherId);
  Future<Either> getTeacherByName(String name);
  Future<Either> getScheduleTeacher(String name);
  Future<Either> getTeacher();
  Future<Either> getRoles();
  Future<Either> createRoles(String role);
  Future<Either> updateRoles(RoleEntity role);
  Future<Either> deleteRole(int idRole);
  Future<Either> getKepalaSekolah();
  Future<Either> getWaka();
  Future<Either> getHonor();
}
