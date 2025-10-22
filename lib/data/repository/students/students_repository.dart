import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/update_user.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/user.dart';
import 'package:new_sistem_informasi_smanda/data/sources/students/students_firebase_service.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/students/students.dart';

import '../../../domain/entities/auth/user.dart';
import '../../../service_locator.dart';
import '../../models/kelas/class.dart';

class StudentsRepositoryImpl extends StudentRepository {
  @override
  Future<Either> getStudentsByClass(String kelas) async {
    var returnedData =
        await sl<StudentsFirebaseService>().getStudentsByClass(kelas);
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
  Future<Either> getStudent() async {
    var user = await sl<StudentsFirebaseService>().getStudent();
    return user.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(UserModel.fromMap(data).toEntity());
      },
    );
  }

  @override
  Future<Either> updateStudent(UpdateUserReq updateUserReq) async {
    return await sl<StudentsFirebaseService>().updateStudent(updateUserReq);
  }

  @override
  Future<Either> deleteStudent(String nisnStudent) async {
    return await sl<StudentsFirebaseService>().deleteStudent(nisnStudent);
  }

  @override
  Future<Either> searchStudentByNISN(String nisnStudent) async {
    var returnedData =
        await sl<StudentsFirebaseService>().searchStudentByNISN(nisnStudent);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(UserModel.fromMap(data).toEntity());
      },
    );
  }

  @override
  Future<Either> getStudentsByname(String name) async {
    var returnedData =
        await sl<StudentsFirebaseService>().getStudentsByname(name);
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
  Future<Either> deleteStudentByClass(String kelas) async {
    return await sl<StudentsFirebaseService>().deleteStudentByClass(kelas);
  }

  @override
  Future<Either> getStudentByRegister() async {
    var returnedData =
        await sl<StudentsFirebaseService>().getStudentByRegister();
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
  Future<Either> acceptStudentAccount(UserEntity student) async {
    return await sl<StudentsFirebaseService>().acceptStudentAccount(student);
  }

  @override
  Future<Either> getAllKelas() async {
    var returnedData = await sl<StudentsFirebaseService>().getAllKelas();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map(
                (e) => KelasModel.fromMap(e).toEntity(),
              )
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> acceptAllStudentAccount() async {
    return await sl<StudentsFirebaseService>().acceptAllStudentAccount();
  }
}
