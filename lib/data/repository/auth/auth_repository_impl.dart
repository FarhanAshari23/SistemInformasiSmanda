import 'package:dartz/dartz.dart';

import '../../../domain/entities/student/student.dart';
import '../../../domain/repository/auth/auth.dart';
import '../../../service_locator.dart';
import '../../models/student/student.dart';
import '../../models/teacher/teacher.dart';
import '../../sources/auth/auth_firebase_service.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signin(StudentEntity signinUserReq) async {
    return await sl<AuthFirebaseService>().signin(signinUserReq);
  }

  @override
  Future<Either> isAdmin() async {
    return await sl<AuthFirebaseService>().isAdmin();
  }

  @override
  Future<Either> getUser(String user) async {
    var userLogin = await sl<AuthFirebaseService>().getUser(user);
    return userLogin.fold(
      (error) {
        return Left(error);
      },
      (data) {
        return user == "Students"
            ? Right(StudentModel.fromMap(data).toEntity())
            : Right(TeacherModel.fromMap(data).toEntity());
      },
    );
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

  @override
  Future<Either> isTeacher() async {
    return await sl<AuthFirebaseService>().isTeacher();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await sl<AuthFirebaseService>().isLoggedIn();
  }
}
