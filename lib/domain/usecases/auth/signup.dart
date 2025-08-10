import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../data/models/auth/user_creation_req.dart';
import '../../../service_locator.dart';
import '../../repository/auth/auth.dart';

class SignUpUseCase implements Usecase<Either, UserCreationReq> {
  @override
  Future<Either> call({UserCreationReq? params}) async {
    return await sl<AuthRepository>().signUp(params!);
  }
}
