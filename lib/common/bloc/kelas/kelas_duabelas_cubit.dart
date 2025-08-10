import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/kelas_display_state.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/students/get_duabelas.dart';

import '../../../service_locator.dart';

class KelasDuabelasCubit extends Cubit<KelasDisplayState> {
  KelasDuabelasCubit() : super(KelasDisplayLoading());

  void displayDuabelas() async {
    var returnedData = await sl<GetDuabelasUsecase>().call();

    returnedData.fold((message) {
      emit(KelasDisplayFailure(message: message));
    }, (data) {
      emit(KelasDisplayLoaded(kelas: data));
    });
  }
}
