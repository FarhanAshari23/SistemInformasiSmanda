import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/auth/is_logged_in_usecase.dart';
import '../../../service_locator.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(DisplaySplash());

  void appStarted() async {
    final results = await Future.wait([
      sl<IsLoggedInUsecase>().call(),
      Future.delayed(const Duration(seconds: 2)),
    ]);

    final bool isLoggedIn = results[0] as bool;

    if (isLoggedIn) {
      emit(Authenticated());
    } else {
      emit(UnAuthenticated());
    }
  }
}
