import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/schedule/get_all_jadwal.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageSchedule/bloc/get_all_jadwal_state.dart';

import '../../../service_locator.dart';

class GetAllJadwalCubit extends Cubit<GetAllJadwalState> {
  GetAllJadwalCubit() : super(GetAllJadwalLoading());

  void displayAllJadwal({dynamic params}) async {
    var returnedData = await sl<GetAllJadwalUsecase>().call();
    returnedData.fold(
      (error) {
        return emit(GetAllJadwalFailure());
      },
      (data) {
        return emit(GetAllJadwalLoaded(jadwals: data));
      },
    );
  }
}
