import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/attendance/get_list_attendaces_teacher_usecase.dart';
import '../../../domain/usecases/attendance/get_list_attendances_student.dart';
import '../../../domain/usecases/attendance/get_list_completions_teacher_usecase.dart';
import '../../../service_locator.dart';
import 'display_date_state.dart';

class DisplayDateCubit extends Cubit<DisplayDateState> {
  DisplayDateCubit() : super(DisplayDateLoading());

  void displayStudentAttendances() async {
    emit(DisplayDateLoading());
    var returnedData = await sl<GetListStudentAttendancesUseCase>().call();
    returnedData.fold(
      (error) {
        return emit(DisplayDateFailure(errorMessage: error));
      },
      (data) {
        return emit(DisplayDateLoaded(attendances: data));
      },
    );
  }

  void displayTeacherAttendances() async {
    emit(DisplayDateLoading());
    var returnedData = await sl<GetListTeacherAttendancesUseCase>().call();
    returnedData.fold(
      (error) {
        return emit(DisplayDateFailure(errorMessage: error));
      },
      (data) {
        return emit(DisplayDateLoaded(attendances: data));
      },
    );
  }

  void displayTeacherCompletions() async {
    emit(DisplayDateLoading());
    var returnedData = await sl<GetListTeacherCompletionsUseCase>().call();
    returnedData.fold(
      (error) {
        return emit(DisplayDateFailure(errorMessage: error));
      },
      (data) {
        return emit(DisplayDateLoaded(attendances: data));
      },
    );
  }
}
