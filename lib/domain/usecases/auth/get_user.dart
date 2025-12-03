import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/auth/auth.dart';

class GetUserUsecase implements Usecase<Either, String> {
  @override
  Future<Either> call({String? params}) async {
    return await sl<AuthRepository>().getUser(params!);
  }
}
