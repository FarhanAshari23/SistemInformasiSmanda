import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/teacher/get_teacher.dart';

import '../../../domain/entities/teacher/teacher.dart';
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
        return emit(TeacherLoaded(teacher: data));
      },
    );
  }

  void selectItem(String? value) {
    final currentState = state;
    if (currentState is TeacherLoaded) {
      // cari guru berdasarkan nama
      final teacher = currentState.teacher.firstWhere(
        (t) => t.nama == value,
        orElse: () => TeacherEntity(
          nama: '',
          mengajar: '',
          nip: '',
          jabatan: '',
          tanggalLahir: '',
          waliKelas: '',
          gender: 0,
        ),
      );

      // ubah string menjadi list (pisah berdasarkan koma)
      final activities = teacher.mengajar
          .split(',')
          .map((e) => e.trim()) // hapus spasi di setiap sisi
          .toList();

      emit(currentState.copyWith(
        selected: value,
        selectedActivities: activities,
      ));
    }
  }
}
