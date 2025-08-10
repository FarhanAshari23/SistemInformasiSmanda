import 'package:flutter_bloc/flutter_bloc.dart';

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

  void displayInitial() {
    emit(StudentsDisplayInitial());
  }
}
