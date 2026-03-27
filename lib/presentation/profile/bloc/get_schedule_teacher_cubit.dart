import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/schedule/get_jadwal_guru_usecase.dart';
import '../../../service_locator.dart';
import 'get_schedule_teacher_state.dart';

class GetScheduleTeacherCubit extends Cubit<GetScheduleTeacherState> {
  GetScheduleTeacherCubit() : super(GetScheduleTeacherLoading());

  Future<void> getJadwalGuru(int teacherId) async {
    var jadwalGuru = await sl<GetJadwalGuruUsecase>().call(params: teacherId);
    jadwalGuru.fold(
      (l) {
        emit(GetScheduleTeacherFailure(errorMessage: l.toString()));
      },
      (jadwal) {
        emit(
          GetScheduleTeacherLoaded(teacherSchedule: jadwal),
        );
      },
    );
  }
}
