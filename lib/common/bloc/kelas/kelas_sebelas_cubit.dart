import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/kelas_display_state.dart';

import '../../../domain/usecases/students/get_sebelas.dart';
import '../../../service_locator.dart';

class KelasSebelasCubit extends Cubit<KelasDisplayState> {
  KelasSebelasCubit() : super(KelasDisplayLoading());

  void displaySebelas() async {
    var returnedData = await sl<GetSebelasUsecase>().call();

    returnedData.fold((message) {
      emit(KelasDisplayFailure(message: message));
    }, (data) {
      emit(KelasDisplayLoaded(kelas: data));
    });
  }
}
