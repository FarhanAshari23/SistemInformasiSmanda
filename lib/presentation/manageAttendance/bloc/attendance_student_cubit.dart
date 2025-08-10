import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecase/usecase.dart';
import 'attendance_student_state.dart';

class AttendanceStudentCubit extends Cubit<AttendanceStudentState> {
  final Usecase usecase;
  AttendanceStudentCubit({required this.usecase})
      : super(AttendanceStudentInitial());

  void displayAttendanceStudent({dynamic params}) async {
    emit(AttendanceStudentLoading());
    var returnedData = await usecase.call(
      params: params,
    );
    returnedData.fold(
      (error) {
        emit(AttendanceStudentFailure());
      },
      (data) {
        emit(AttendanceStudentLoaded(students: data));
      },
    );
  }

  void displayInitial() {
    emit(AttendanceStudentInitial());
  }
}
