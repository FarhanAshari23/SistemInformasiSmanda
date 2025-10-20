import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/data/models/teacher/teacher.dart';
import 'package:new_sistem_informasi_smanda/data/sources/teacher/teacher_firebase_service.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/teacher.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/teacher/teacher.dart';

import '../../../service_locator.dart';

class TeacherRepositoryImpl extends TeacherRepository {
  @override
  Future<Either> getKepalaSekolah() async {
    var returnedData = await sl<TeacherFirebaseService>().getKepalaSekolah();
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
  Future<Either> getWaka() async {
    var returnedData = await sl<TeacherFirebaseService>().getWaka();
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
  Future<Either> createTeacher(TeacherModel teacherCreationReq) async {
    return await sl<TeacherFirebaseService>().createTeacher(teacherCreationReq);
  }

  @override
  Future<Either> deleteTeacher(TeacherEntity teacherReq) async {
    return await sl<TeacherFirebaseService>().deleteTeacher(teacherReq);
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
  Future<Either> getHonor() async {
    var returnedData = await sl<TeacherFirebaseService>().getHonor();
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
}
