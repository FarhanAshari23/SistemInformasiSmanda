import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecase/usecase.dart';
import 'student_nisn_state.dart';

class StudentsNISNCubit extends Cubit<StudentsNISNState> {
  final Usecase usecase;
  StudentsNISNCubit({required this.usecase}) : super(StudentsNISNInitial());

  void displayStudents({dynamic params}) async {
    emit(StudentsNISNLoading());
    var returnedData = await usecase.call(
      params: params,
    );
    returnedData.fold(
      (error) {
        emit(StudentsNISNFailure());
      },
      (data) {
        emit(StudentsNISNLoaded(student: data));
      },
    );
  }

  void displayInitial() {
    emit(StudentsNISNInitial());
  }
}
