import 'package:flutter_bloc/flutter_bloc.dart';

class EditStateButtonCubit extends Cubit<String> {
  EditStateButtonCubit() : super('');

  // Fungsi untuk mengubah nilai
  void updateValue(String newValue) {
    emit(newValue);
  }
}
