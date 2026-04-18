import 'package:flutter_bloc/flutter_bloc.dart';

import 'form_field_state.dart';

class FormFieldCubit extends Cubit<FormFieldsState> {
  FormFieldCubit() : super(FormFieldsState());

  void updateClass(String value) {
    emit(state.copyWith(classValue: value));
  }

  void updateTeacher(String value) {
    emit(state.copyWith(teacherValue: value));
  }
}
