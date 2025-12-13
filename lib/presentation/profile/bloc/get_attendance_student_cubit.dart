import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';

import '../../../domain/usecases/attendance/get_attendance_student_usecase.dart';
import '../../../service_locator.dart';
import 'get_attendance_student_state.dart';

class GetStudentAttendanceCubit extends Cubit<GetAttendanceStudentState> {
  GetStudentAttendanceCubit() : super(GetAttendanceStudentLoading());

  Future<void> getAttendanceStudent(UserEntity student) async {
    var studentAttendance =
        await sl<GetAttendanceStudentUsecase>().call(params: student);
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
