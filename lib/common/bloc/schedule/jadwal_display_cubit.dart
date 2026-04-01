import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/schedule/get_jadwal.dart';
import '../../../domain/usecases/schedule/get_jadwal_guru_usecase.dart';
import '../../../service_locator.dart';
import 'jadwal_display_state.dart';

class JadwalDisplayCubit extends Cubit<JadwalDisplayState> {
  JadwalDisplayCubit() : super(JadwalDisplayLoading());

  void displayJadwal({int? params}) async {
    var returnedData = await sl<GetJadwalUsecase>().call(params: params);
    returnedData.fold(
      (error) {
        return emit(JadwalDisplayFailure());
      },
      (data) {
        return emit(JadwalDisplayLoaded(jadwals: data));
      },
    );
  }

  void displayJadwalGuru({int? params}) async {
    var returnedData = await sl<GetJadwalGuruUsecase>().call(params: params);
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
