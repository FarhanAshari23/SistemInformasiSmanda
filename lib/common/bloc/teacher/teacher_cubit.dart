import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/teacher/teacher.dart';
import '../../../domain/usecases/teacher/get_teacher.dart';
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
        return emit(TeacherLoaded(teachers: data));
      },
    );
  }

  void selectItem(String? value) {
    final currentState = state;
    if (currentState is TeacherLoaded) {
      // cari guru berdasarkan nama
      final teacher = currentState.teachers.firstWhere(
        (t) => t.name == value,
        orElse: () => TeacherEntity(
          birthDate: DateTime.now(),
          email: '',
          gender: 0,
          name: '',
          nip: '',
          waliKelas: '',
        ),
      );

      // ubah string menjadi list (pisah berdasarkan koma)
      final activities = teacher.tasksName;

      emit(currentState.copyWith(
        selected: value,
        selectedActivities: activities,
      ));
    }
  }
}
