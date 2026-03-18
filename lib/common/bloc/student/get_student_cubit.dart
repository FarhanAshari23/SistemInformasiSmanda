import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/students/get_student_by_id_usecase.dart';
import '../../../service_locator.dart';
import 'get_student_state.dart';

class StudentCubit extends Cubit<StudentState> {
  StudentCubit() : super(StudentLoading());

  void displayStudentById({int? params}) async {
    var returnedData = await sl<GetStudentByIdUsecase>().call(params: params);
    returnedData.fold(
      (error) {
        return emit(StudentFailure(errorMessage: error));
      },
      (data) {
        return emit(StudentLoaded(student: data));
      },
    );
  }
}
