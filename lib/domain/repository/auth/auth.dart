import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/signin_user_req.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/user_creation_req.dart';

abstract class AuthRepository {
  Future<Either> signin(SignInUserReq signinUserReq);
  Future<Either> signUp(UserCreationReq userCreationReq);
  Future<Either> logout();
  Future<bool> isLoggedIn();
  Future<Either> getUser();
  Future<Either> isAdmin();
}
