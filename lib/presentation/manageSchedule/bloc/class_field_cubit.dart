import 'package:flutter_bloc/flutter_bloc.dart';

class ClassFieldCubit extends Cubit<String> {
  ClassFieldCubit() : super('');

  void updateText(String value) {
    emit(value);
  }
}
