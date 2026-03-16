import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/student/student.dart';
import '../../repository/auth/auth.dart';

class SignUpUseCase implements Usecase<Either, StudentEntity> {
  @override
  Future<Either> call({StudentEntity? params}) async {
    return await sl<AuthRepository>().signUp(params!);
  }
}
