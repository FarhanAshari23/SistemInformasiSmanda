import 'package:dartz/dartz.dart';

import '../../../data/models/auth/update_user.dart';
import '../../entities/auth/user.dart';

abstract class StudentRepository {
  Future<Either> updateStudent(UpdateUserReq updateUserReq);
  Future<Either> acceptStudentAccount(UserEntity student);
  Future<Either> acceptAllStudentAccount();
  Future<Either> deleteStudent(String nisnStudent);
  Future<Either> getAllKelas();
  Future<Either> searchStudentByNISN(String nisnStudent);
  Future<Either> getStudentsByClass(String kelas);
  Future<Either> getStudentByRegister();
  Future<Either> deleteStudentByClass(String kelas);
  Future<Either> getStudentsByname(String name);
}
