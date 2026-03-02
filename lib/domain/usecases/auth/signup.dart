import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/auth/user_golang.dart';
import '../../repository/auth/auth.dart';

class SignUpUseCase implements Usecase<Either, UserGolang> {
  @override
  Future<Either> call({UserGolang? params}) async {
    return await sl<AuthRepository>().signUp(params!);
  }
}
