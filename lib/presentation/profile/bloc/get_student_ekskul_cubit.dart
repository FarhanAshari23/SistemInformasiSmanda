import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/ekskul/get_student_ekskul_usecase.dart';
import '../../../service_locator.dart';
import 'get_student_ekskul_state.dart';

class GetStudentEkskulCubit extends Cubit<GetStudentEkskulState> {
  GetStudentEkskulCubit() : super(GetStudentEkskulLoading());

  Future<void> getStudentEkskul(int studentId) async {
    emit(GetStudentEkskulLoading());
    var teacherSchedule =
        await sl<GetStudentEkskulUsecase>().call(params: studentId);
    teacherSchedule.fold(
      (l) {
        emit(GetStudentEkskulFailure(errorMessage: l.toString()));
      },
      (ekskuls) {
        emit(
          GetStudentEkskulLoaded(ekskuls: ekskuls),
        );
      },
    );
  }
}
