import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/signin_user_req.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/user_creation_req.dart';
import 'package:new_sistem_informasi_smanda/data/sources/auth/auth_firebase_service.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/auth/auth.dart';

import '../../../service_locator.dart';
import '../../models/auth/user.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signin(SignInUserReq signinUserReq) async {
    return await sl<AuthFirebaseService>().signin(signinUserReq);
  }

  @override
  Future<Either> isAdmin() async {
    return await sl<AuthFirebaseService>().isAdmin();
  }

  @override
  Future<Either> getUser() async {
    var user = await sl<AuthFirebaseService>().getUser();
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
  Future<Either> signUp(UserCreationReq userCreationReq) async {
    return await sl<AuthFirebaseService>().signUp(userCreationReq);
  }

  @override
  Future<Either> logout() async {
    return await sl<AuthFirebaseService>().logout();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await sl<AuthFirebaseService>().isLoggedIn();
  }

  @override
  Future<Either> isRegister() async {
    return await sl<AuthFirebaseService>().isRegister();
  }

  @override
  Future<Either> forgotPassword(String email) async {
    return await sl<AuthFirebaseService>().forgotPassword(email);
  }

  @override
  Future<Either> checkEmailUsed(String email) async {
    return await sl<AuthFirebaseService>().checkEmailUsed(email);
  }
}
