import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/core/usecase/usecase.dart';
import 'package:new_sistem_informasi_smanda/data/models/auth/signin_user_req.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/auth/auth.dart';

import '../../../service_locator.dart';

class SignInUsecase implements Usecase<Either, SignInUserReq> {
  @override
  Future<Either> call({SignInUserReq? params}) async {
    return await sl<AuthRepository>().signin(params!);
  }
}
