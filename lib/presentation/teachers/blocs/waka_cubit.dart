import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/teacher/get_waka.dart';
import 'package:new_sistem_informasi_smanda/presentation/teachers/blocs/waka_state.dart';

import '../../../service_locator.dart';

class WakaCubit extends Cubit<WakaState> {
  WakaCubit() : super(WakaLoading());

  void displayWaka({dynamic params}) async {
    var returnedData = await sl<GetWaka>().call();
    returnedData.fold(
      (error) {
        return emit(WakaFailure(errorMessage: error));
      },
      (data) {
        return emit(WakaLoaded(teacher: data));
      },
    );
  }
}
