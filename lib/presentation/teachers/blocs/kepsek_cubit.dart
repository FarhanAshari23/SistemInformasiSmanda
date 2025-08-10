import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/teacher/get_kepala_sekolah.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/blocs/kepsek_state.dart';

import '../../../service_locator.dart';

class KepalaSekolahCubit extends Cubit<KepalaSekolahState> {
  KepalaSekolahCubit() : super(KepalaSekolahLoading());

  void displayKepalaSekolah({dynamic params}) async {
    var returnedData = await sl<GetKepalaSekolah>().call();
    returnedData.fold(
      (error) {
        return emit(KepalaSekolahFailure(errorMessage: error));
      },
      (data) {
        return emit(KepalaSekolahLoaded(teacher: data));
      },
    );
  }
}
