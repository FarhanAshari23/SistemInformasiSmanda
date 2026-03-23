import 'package:dartz/dartz.dart';

import '../../../domain/entities/teacher/role.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/repository/teacher/teacher.dart';
import '../../../service_locator.dart';
import '../../models/teacher/role.dart';
import '../../models/teacher/teacher.dart';
import '../../sources/teacher/teacher_firebase_service.dart';

class TeacherRepositoryImpl extends TeacherRepository {
  @override
  Future<Either> getTeacher() async {
    var returnedData = await sl<TeacherFirebaseService>().getTeacher();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map((e) => TeacherModel.fromMap(e).toEntity())
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> createTeacher(TeacherEntity teacherCreationReq) async {
    return await sl<TeacherFirebaseService>().createTeacher(teacherCreationReq);
  }

  @override
  Future<Either> deleteTeacher(int teacherId) async {
    return await sl<TeacherFirebaseService>().deleteTeacher(teacherId);
  }

  @override
  Future<Either> updateTeacher(TeacherEntity teacherReq) async {
    return await sl<TeacherFirebaseService>().updateTeacher(teacherReq);
  }

  @override
  Future<Either> getTeacherByName(String name) async {
    var returnedData =
        await sl<TeacherFirebaseService>().getTeacherByName(name);
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
  Future<Either> createRoles(String role) async {
    return await sl<TeacherFirebaseService>().createRoles(role);
  }

  @override
  Future<Either> deleteRole(int idRole) async {
    return await sl<TeacherFirebaseService>().deleteRole(idRole);
  }

  @override
  Future<Either> getRoles() async {
    var returnedData = await sl<TeacherFirebaseService>().getRoles();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data).map((e) => RoleModel.fromMap(e).toEntity()).toList(),
        );
      },
    );
  }

  @override
  Future<Either> updateRoles(RoleEntity role) async {
    return await sl<TeacherFirebaseService>().updateRoles(role);
  }

  @override
  Future<Either> getTeacherById(int teacherId) async {
    var returnedData =
        await sl<TeacherFirebaseService>().getTeacherById(teacherId);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          TeacherModel.fromMap(data).toEntity(),
        );
      },
    );
  }
}
