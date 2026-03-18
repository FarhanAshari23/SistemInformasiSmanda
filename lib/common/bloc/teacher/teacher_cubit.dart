import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/teacher/get_teacher.dart';
import '../../../domain/usecases/teacher/get_teacher_by_id_usecase.dart';
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
        return emit(TeacherListLoaded(teachers: data));
      },
    );
  }

  void displayTeacherById({int? params}) async {
    var returnedData = await sl<GetTeacherByIdUsecase>().call(params: params);
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
