import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/usecases/attendance/get_attendance_teacher_usecase.dart';
import '../../../service_locator.dart';
import 'get_teacher_attendance_state.dart';

class GetTeacherAttendanceCubit extends Cubit<GetTeacherAttendanceState> {
  GetTeacherAttendanceCubit() : super(GetTeacherAttendanceLoading());

  Future<void> getAttendanceTeacher(TeacherEntity teacher) async {
    emit(GetTeacherAttendanceLoading());
    var teacherSchedule =
        await sl<GetAttendanceTeacherUsecase>().call(params: teacher);
    teacherSchedule.fold(
      (l) {
        emit(GetTeacherAttendanceFailure(errorMessage: l.toString()));
      },
      (attendance) {
        emit(
          GetTeacherAttendanceLoaded(attendances: attendance),
        );
      },
    );
  }
}
