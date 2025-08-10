import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/ekskul/get_ekskul.dart';

import '../../../service_locator.dart';
import 'ekskul_state.dart';

class EkskulCubit extends Cubit<EkskulState> {
  EkskulCubit() : super(EkskulLoading());

  void displayEkskul({dynamic params}) async {
    var returnedData = await sl<GetEkskulUsecase>().call();
    returnedData.fold(
      (error) {
        return emit(EkskulFailure(errorMessage: error));
      },
      (data) {
        return emit(EkskulLoaded(ekskul: data));
      },
    );
  }
}
