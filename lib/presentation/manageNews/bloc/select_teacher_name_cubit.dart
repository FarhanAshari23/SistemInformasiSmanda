import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecase/usecase.dart';
import 'select_teacher_name_state.dart';

class GetTeacherNameCubit extends Cubit<GetTeacherNameState> {
  final Usecase usecase;
  GetTeacherNameCubit({required this.usecase}) : super(GetTeacherNameInitial());

  void displayTeacher({dynamic params}) async {
    emit(GetTeacherNameLoading());
    var returnedData = await usecase.call(
      params: params,
    );
    returnedData.fold(
      (error) {
        emit(GetTeacherNameFailure(errorMessage: error.toString()));
      },
      (data) {
        emit(GetTeacherNameLoaded(teachers: data));
      },
    );
  }

  void displayInitial() {
    emit(GetTeacherNameInitial());
  }
}
