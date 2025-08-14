import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/students/get_students_register.dart';
import 'package:new_sistem_informasi_smanda/presentation/manageStudent/bloc/get_student_registration_state.dart';

import '../../../service_locator.dart';

class GetStudentRegistrationCubit extends Cubit<StudentsRegistrationState> {
  GetStudentRegistrationCubit() : super(StudentsRegistrationLoading());

  void displayStudentRegistration({dynamic params}) async {
    var returnedData = await sl<GetStudentsRegisterUsecase>().call();
    returnedData.fold(
      (error) {
        return emit(StudentsRegistrationFailure());
      },
      (data) {
        return emit(StudentsRegistrationLoaded(students: data));
      },
    );
  }
}
