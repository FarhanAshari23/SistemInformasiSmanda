import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/auth/auth.dart';

class IsLoggedInUsecase implements Usecase<bool, dynamic> {
  @override
  Future<bool> call({dynamic params}) async {
    return sl<AuthRepository>().isLoggedIn();
  }
}
