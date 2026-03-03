import 'package:dartz/dartz.dart';

import '../../../data/models/auth/update_user.dart';

abstract class StudentRepository {
  Future<Either> updateStudent(UpdateUserReq updateUserReq);
  Future<Either> acceptStudentAccount(int studentId);
  Future<Either> acceptAllStudentAccount();
  Future<Either> deleteAllStudentAccount();
  Future<Either> deleteStudent(int studentId);
  Future<Either> getAllKelas();
  Future<Either> searchStudentByNISN(String nisnStudent);
  Future<Either> getStudentsByClass(String kelas);
  Future<Either> getStudentByRegister();
  Future<Either> deleteStudentByClass(String kelas);
  Future<Either> getStudentsByname(String name);
  Future<Either> createExcellForStudentData();
  Future<Either> getAllStudentGolang();
}
