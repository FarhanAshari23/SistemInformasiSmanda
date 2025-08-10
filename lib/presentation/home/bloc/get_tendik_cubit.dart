import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/teacher/get_honor.dart';
import 'package:new_sistem_informasi_smanda/presentation/home/bloc/teacher_state.dart';

import '../../../service_locator.dart';

class GetTendikCubit extends Cubit<TeacherState> {
  GetTendikCubit() : super(TeacherLoading());

  void displayTendik({dynamic params}) async {
    var returnedData = await sl<GetHonor>().call();
    returnedData.fold(
      (error) {
        return emit(TeacherFailure(errorMessage: error));
      },
      (data) {
        return emit(TeacherLoaded(teacher: data));
      },
    );
  }
}
