import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/auth/auth.dart';

class CheckEmailUsecase implements Usecase<Either, String?> {
  @override
  Future<Either> call({params}) async {
    return await sl<AuthRepository>().checkEmailUsed(params!);
  }
}
