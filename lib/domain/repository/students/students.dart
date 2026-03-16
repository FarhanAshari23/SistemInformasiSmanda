import 'package:dartz/dartz.dart';

import '../../entities/student/student.dart';

abstract class StudentRepository {
  Future<Either> updateStudent(StudentEntity updateUserReq);
  Future<Either> acceptStudentAccount(int studentId);
  Future<Either> acceptAllStudentAccount();
  Future<Either> deleteAllStudentAccount();
  Future<Either> deleteStudent(int studentId);
  Future<Either> searchStudentByNISN(String nisnStudent);
  Future<Either> getStudentsByClass(int kelasId);
  Future<Either> getStudentByRegister();
  Future<Either> deleteStudentByClass(String kelas);
  Future<Either> getStudentsByname(String name);
  Future<Either> createExcellForStudentData();
}
