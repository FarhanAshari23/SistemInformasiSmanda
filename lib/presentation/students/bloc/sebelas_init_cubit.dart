import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/students_state.dart';

import '../../../domain/usecases/students/get_sebelas_init.dart';
import '../../../service_locator.dart';

class SebelasInitCubit extends Cubit<StudentsDisplayState> {
  SebelasInitCubit() : super(StudentsDisplayLoading());

  void displaySebelasInit({dynamic params}) async {
    var returnedData = await sl<GetSebelasInitUsecase>().call();
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
