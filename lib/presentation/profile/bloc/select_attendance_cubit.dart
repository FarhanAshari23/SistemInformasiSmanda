import 'package:flutter_bloc/flutter_bloc.dart';

class SelectAttendanceCubit extends Cubit<int> {
  SelectAttendanceCubit() : super(0);

  void stateAttendance(int value) {
    emit(value);
  }
}
