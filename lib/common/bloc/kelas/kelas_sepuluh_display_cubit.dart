import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/kelas_display_state.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/students/get_sepuluh.dart';

import '../../../service_locator.dart';

class KelasSepuluhDisplayCubit extends Cubit<KelasDisplayState> {
  KelasSepuluhDisplayCubit() : super(KelasDisplayLoading());

  void displaySepuluh() async {
    var returnedData = await sl<GetSepuluhUsecase>().call();

    returnedData.fold((message) {
      emit(KelasDisplayFailure(message: message));
    }, (data) {
      emit(KelasDisplayLoaded(kelas: data));
    });
  }
}
