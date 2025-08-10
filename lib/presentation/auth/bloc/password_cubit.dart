import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordCubit extends Cubit<bool> {
  PasswordCubit() : super(true); // Awalnya password hidden

  void togglePasswordVisibility() {
    emit(!state); // Toggle visibility
  }
}
