import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/students/get_all_kelas_usecase.dart';

import 'kelas_display_state.dart';
import '../../../service_locator.dart';

class GetAllKelasCubit extends Cubit<KelasDisplayState> {
  GetAllKelasCubit() : super(KelasDisplayLoading());

  void displayAll() async {
    var returnedData = await sl<GetAllKelasUsecase>().call();

    returnedData.fold((message) {
      emit(KelasDisplayFailure(message: message));
    }, (data) {
      emit(KelasDisplayLoaded(kelas: data));
    });
  }

  void selectItem(String? value) {
    final currentState = state;
    if (currentState is KelasDisplayLoaded) {
      emit(currentState.copyWith(selected: value));
    }
  }
}
