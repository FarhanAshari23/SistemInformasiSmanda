import 'package:dartz/dartz.dart';

import '../../../domain/entities/student/student.dart';
import '../../../domain/repository/students/students.dart';
import '../../../service_locator.dart';
import '../../models/student/student.dart';
import '../../sources/students/students_firebase_service.dart';

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
                (e) => StudentModel.fromMap(e).toEntity(),
              )
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> updateStudent(StudentEntity updateUserReq) async {
    return await sl<StudentsFirebaseService>().updateStudent(updateUserReq);
  }

  @override
  Future<Either> deleteStudent(int studentId) async {
    return await sl<StudentsFirebaseService>().deleteStudent(studentId);
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
        return Right(StudentModel.fromMap(data).toEntity());
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
                (e) => StudentModel.fromMap(e).toEntity(),
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
                (e) => StudentModel.fromMap(e).toEntity(),
              )
              .toList(),
        );
      },
    );
  }

  @override
  Future<Either> acceptStudentAccount(int studentId) async {
    return await sl<StudentsFirebaseService>().acceptStudentAccount(studentId);
  }

  @override
  Future<Either> acceptAllStudentAccount() async {
    return await sl<StudentsFirebaseService>().acceptAllStudentAccount();
  }

  @override
  Future<Either> deleteAllStudentAccount() async {
    return await sl<StudentsFirebaseService>().deleteAllStudentAccount();
  }

  @override
  Future<Either> createExcellForStudentData() async {
    return await sl<StudentsFirebaseService>().createExcellForStudentData();
  }

  @override
  Future<Either> getAllStudentGolang() async {
    var returnedData =
        await sl<StudentsFirebaseService>().getAllStudentGolang();
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(
          List.from(data)
              .map(
                (e) => StudentModel.fromMap(e).toEntity(),
              )
              .toList(),
        );
      },
    );
  }
}
