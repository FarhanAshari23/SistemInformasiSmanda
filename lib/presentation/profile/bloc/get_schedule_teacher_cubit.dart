import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/teacher/get_schedule_teacher_usecase.dart';
import '../../../service_locator.dart';
import 'get_schedule_teacher_state.dart';

class GetScheduleTeacherCubit extends Cubit<GetScheduleTeacherState> {
  GetScheduleTeacherCubit() : super(GetScheduleTeacherLoading());

  Future<void> getScheduleTeacher(String name) async {
    var teacherSchedule =
        await sl<GetScheduleTeacherUsecase>().call(params: name);
    teacherSchedule.fold(
      (l) {
        emit(GetScheduleTeacherFailure());
      },
      (schedule) {
        emit(
          GetScheduleTeacherLoaded(teacherSchedule: schedule),
        );
      },
    );
  }
}
