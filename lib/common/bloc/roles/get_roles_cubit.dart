import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/teacher/get_roles_usecase.dart';

import '../../../service_locator.dart';
import 'get_roles_state.dart';

class GetRolesCubit extends Cubit<GetRolesState> {
  GetRolesCubit() : super(GetRolesLoading());

  void displayRoles({dynamic params}) async {
    var returnedData = await sl<GetRolesUsecase>().call();
    returnedData.fold(
      (error) {
        return emit(GetRolesFailure(errorMessage: error.toString()));
      },
      (data) {
        return emit(GetRolesLoaded(
          roles: data,
        ));
      },
    );
  }

  void selectItem(String? value) {
    final currentState = state;
    if (currentState is GetRolesLoaded) {
      emit(currentState.copyWith(selected: value));
    }
  }
}
