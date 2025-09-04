import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/teacher/get_teacher.dart';

import '../../../service_locator.dart';
import 'teacher_state.dart';

class TeacherCubit extends Cubit<TeacherState> {
  TeacherCubit() : super(TeacherLoading());

  void displayTeacher({dynamic params}) async {
    var returnedData = await sl<GetTeacher>().call();
    returnedData.fold(
      (error) {
        return emit(TeacherFailure(errorMessage: error));
      },
      (data) {
        return emit(TeacherLoaded(teacher: data));
      },
    );
  }

  void selectItem(String? value) {
    final currentState = state;
    if (currentState is TeacherLoaded) {
      emit(currentState.copyWith(selected: value));
    }
  }
}
