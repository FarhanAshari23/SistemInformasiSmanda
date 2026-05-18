import 'package:dartz/dartz.dart';

import '../../../domain/entities/student/student.dart';
import '../../../domain/repository/auth/auth.dart';
import '../../../service_locator.dart';
import '../../sources/auth/auth_firebase_service.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signin(StudentEntity signinUserReq) async {
    return await sl<AuthFirebaseService>().signin(signinUserReq);
  }

  @override
  Future<Either> signUp(StudentEntity userCreationReq) async {
    return await sl<AuthFirebaseService>().signUp(userCreationReq);
  }

  @override
  Future<Either> logout() async {
    return await sl<AuthFirebaseService>().logout();
  }

  @override
  Future<Either> forgotPassword(String email) async {
    return await sl<AuthFirebaseService>().forgotPassword(email);
  }

  @override
  Future<bool> isLoggedIn() async {
    return await sl<AuthFirebaseService>().isLoggedIn();
  }

  @override
  Future<Either> userValidation(String email) async {
    var returnedData = await sl<AuthFirebaseService>().userValidation(email);
    return returnedData.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return Right(data);
      },
    );
  }
}
