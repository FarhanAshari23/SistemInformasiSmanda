import 'package:dartz/dartz.dart';

import '../../entities/student/student.dart';

abstract class AuthRepository {
  Future<Either> signin(StudentEntity signinUserReq);
  Future<Either> signUp(StudentEntity userCreationReq);
  Future<Either> forgotPassword(String email);
  Future<Either> checkEmailUsed(String email);
  Future<Either> logout();
  Future<bool> isLoggedIn();
  Future<Either> getUser(String user);
  Future<Either> isAdmin();
  Future<Either> isRegister();
  Future<Either> isTeacher();
}
