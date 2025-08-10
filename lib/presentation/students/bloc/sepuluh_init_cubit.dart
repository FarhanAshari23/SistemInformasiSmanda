import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/kelas/students_state.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/students/get_sepuluh_init.dart';

import '../../../service_locator.dart';

class SepuluhInitCubit extends Cubit<StudentsDisplayState> {
  SepuluhInitCubit() : super(StudentsDisplayLoading());

  void displaySepuluhInit({dynamic params}) async {
    var returnedData = await sl<GetSepuluhInitUsecase>().call();
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
