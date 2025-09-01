import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/students/get_students_with_kelas.dart';

import '../../../core/usecase/usecase.dart';
import 'students_state.dart';

class StudentsDisplayCubit extends Cubit<StudentsDisplayState> {
  final Usecase usecase;
  StudentsDisplayCubit({required this.usecase})
      : super(StudentsDisplayInitial());

  void displayStudents({dynamic params}) async {
    emit(StudentsDisplayLoading());
    var returnedData = await usecase.call(
      params: params,
    );
    returnedData.fold(
      (error) {
        emit(StudentsDisplayFailure());
      },
      (data) {
        emit(StudentsDisplayLoaded(students: data));
      },
    );
  }

  void displayStudentsInit({required String params}) async {
    emit(StudentsDisplayLoading());
    var returnedData = await GetStudentsWithKelas().call(params: params);
    returnedData.fold(
      (error) {
        emit(StudentsDisplayFailure());
      },
      (data) {
        emit(StudentsDisplayLoaded(students: data));
      },
    );
  }

  void displayInitial() {
    emit(StudentsDisplayInitial());
  }
}
