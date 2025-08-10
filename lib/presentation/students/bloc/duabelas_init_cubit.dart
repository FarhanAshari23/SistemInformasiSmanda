import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/students_state.dart';

import '../../../domain/usecases/students/get_duabelas_init.dart';
import '../../../service_locator.dart';

class DuabelasInitCubit extends Cubit<StudentsDisplayState> {
  DuabelasInitCubit() : super(StudentsDisplayLoading());

  void displayDuabelasInit({dynamic params}) async {
    var returnedData = await sl<GetDuabelasInitUsecase>().call();
    returnedData.fold(
      (error) {
        return emit(StudentsDisplayFailure());
      },
      (data) {
        return emit(StudentsDisplayLoaded(students: data));
      },
    );
  }
}
