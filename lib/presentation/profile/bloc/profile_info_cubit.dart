import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/auth/get_user.dart';
import '../../../service_locator.dart';
import 'profile_info_state.dart';

class ProfileInfoCubit extends Cubit<ProfileInfoState> {
  ProfileInfoCubit() : super(ProfileInfoLoading());

  Future<void> getUser(String user) async {
    var userLogin = await sl<GetUserUsecase>().call(params: user);
    userLogin.fold(
      (l) {
        emit(ProfileInfoFailure());
      },
      (currentUser) {
        emit(
          user == "Students"
              ? ProfileInfoLoaded(userEntity: currentUser)
              : ProfileInfoLoaded(teacherEntity: currentUser),
        );
      },
    );
  }
}
