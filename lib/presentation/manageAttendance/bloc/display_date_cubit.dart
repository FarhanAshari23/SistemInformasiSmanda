import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/attendance/get_list_attendances.dart';

import '../../../service_locator.dart';
import 'display_date_state.dart';

class DisplayDateCubit extends Cubit<DisplayDateState> {
  DisplayDateCubit() : super(DisplayDateLoading());

  void displayAttendances(String nameCollection) async {
    var returnedData =
        await sl<GetListAttendancesUseCase>().call(params: nameCollection);
    returnedData.fold(
      (error) {
        return emit(DisplayDateFailure(errorMessage: error));
      },
      (data) {
        return emit(DisplayDateLoaded(attendances: data));
      },
    );
  }
}
