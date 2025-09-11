import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/schedule/get_activities_usecase.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/activities/get_activities_state.dart';

import '../../../service_locator.dart';

class GetActivitiesCubit extends Cubit<GetActivitiesState> {
  GetActivitiesCubit() : super(GetActivitiesLoading());

  void displayActivites({dynamic params}) async {
    var returnedData = await sl<GetActivitiesUsecase>().call();
    returnedData.fold(
      (error) {
        return emit(GetActivitiesFailure(errorMessage: error));
      },
      (data) {
        return emit(GetActivitiesLoaded(
          activities: data,
        ));
      },
    );
  }

  void selectItem(String? value) {
    final currentState = state;
    if (currentState is GetActivitiesLoaded) {
      emit(currentState.copyWith(selected: value));
    }
  }
}
