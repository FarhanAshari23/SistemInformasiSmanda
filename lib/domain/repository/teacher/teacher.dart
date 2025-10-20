import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/teacher.dart';

import '../../../data/models/teacher/teacher.dart';

abstract class TeacherRepository {
  Future<Either> createTeacher(TeacherModel teacherCreationReq);
  Future<Either> updateTeacher(TeacherEntity teacherReq);
  Future<Either> deleteTeacher(TeacherEntity teacherReq);
  Future<Either> getTeacher();
  Future<Either> getTeacherByName(String name);
  Future<Either> getKepalaSekolah();
  Future<Either> getWaka();
  Future<Either> getHonor();
}
