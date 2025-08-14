import 'package:dartz/dartz.dart';

import '../../../data/models/auth/update_user.dart';

abstract class StudentRepository {
  Future<Either> updateStudent(UpdateUserReq updateUserReq);
  Future<Either> deleteStudent(String nisnStudent);
  Future<Either> getKelasSepuluh();
  Future<Either> getKelasSebelas();
  Future<Either> getKelasDuabelas();
  Future<Either> searchStudentByNISN(String nisnStudent);
  Future<Either> getStudent();
  Future<Either> getStudentsByClass(String kelas);
  Future<Either> getStudentByRegister();
  Future<Either> getClassSepuluhInit();
  Future<Either> getClassSebelasInit();
  Future<Either> getClassDuabelasInit();
  Future<Either> deleteStudentByClass(String kelas);
  Future<Either> getStudentsByname(String name);
}
