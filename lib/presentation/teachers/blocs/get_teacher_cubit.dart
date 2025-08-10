import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecase/usecase.dart';
import 'get_teacher_state.dart';

class GetTeacherCubit extends Cubit<GetTeacherState> {
  final Usecase usecase;
  GetTeacherCubit({required this.usecase}) : super(GetTeacherInitial());

  void displayTeacher({dynamic params}) async {
    emit(GetTeacherLoading());
    var returnedData = await usecase.call(
      params: params,
    );
    returnedData.fold(
      (error) {
        emit(GetTeacherFailure());
      },
      (data) {
        emit(GetTeacherLoaded(teachers: data));
      },
    );
  }

  void displayInitial() {
    emit(GetTeacherInitial());
  }
}
