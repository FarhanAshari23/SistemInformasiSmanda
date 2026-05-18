import 'package:dartz/dartz.dart';

import '../../entities/student/student.dart';

abstract class AuthRepository {
  Future<Either> signin(StudentEntity signinUserReq);
  Future<Either> signUp(StudentEntity userCreationReq);
  Future<Either> userValidation(String email);
  Future<Either> forgotPassword(String email);
  Future<Either> logout();
  Future<bool> isLoggedIn();
}
