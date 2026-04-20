import 'package:flutter_bloc/flutter_bloc.dart';

class EditStateButtonCubit extends Cubit<String> {
  EditStateButtonCubit() : super('');

  void updateValue(String newValue) {
    emit(newValue);
  }
}
