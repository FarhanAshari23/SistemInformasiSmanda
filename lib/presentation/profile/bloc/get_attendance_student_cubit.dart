import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/attendance/get_attendance_student_usecase.dart';
import '../../../service_locator.dart';
import 'get_attendance_student_state.dart';

class GetStudentAttendanceCubit extends Cubit<GetAttendanceStudentState> {
  GetStudentAttendanceCubit() : super(GetAttendanceStudentLoading());

  Future<void> getAttendanceStudent(int studentId) async {
    var studentAttendance =
        await sl<GetAttendanceStudentUsecase>().call(params: studentId);
    studentAttendance.fold(
      (l) {
        emit(GetAttendanceStudentFailure(errorMessage: l.toString()));
      },
      (attendance) {
        emit(
          GetAttendanceStudentLoaded(attendances: attendance),
        );
      },
    );
  }
}
