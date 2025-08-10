import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/schedule/get_jadwal.dart';
import '../../../service_locator.dart';
import 'jadwal_display_state.dart';

class JadwalDisplayCubit extends Cubit<JadwalDisplayState> {
  JadwalDisplayCubit() : super(JadwalDisplayLoading());

  void displayJadwal({dynamic params}) async {
    var returnedData = await sl<GetJadwalUsecase>().call();
    returnedData.fold(
      (error) {
        return emit(JadwalDisplayFailure());
      },
      (data) {
        return emit(JadwalDisplayLoaded(jadwals: data));
      },
    );
  }
}
