import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/attandance/param_attendance_teacher.dart';
import '../../../domain/usecases/attendance/get_attendance_all_teacher_usecase.dart';
import '../../../service_locator.dart';
import 'attendance_teacher_state.dart';

class AttendanceTeacherCubit extends Cubit<AttendanceTeacherState> {
  AttendanceTeacherCubit() : super(AttendanceTeacherLoading());

  void displayAttendanceTeacher(ParamAttendanceTeacher req) async {
    emit(AttendanceTeacherLoading());
    var returnedData =
        await sl<GetAttendanceAllTeacherUsecase>().call(params: req);
    returnedData.fold(
      (error) {
        return emit(AttendanceTeacherFailure(errorMessage: error));
      },
      (data) {
        return emit(AttendanceTeacherLoaded(teachers: data));
      },
    );
  }
}
