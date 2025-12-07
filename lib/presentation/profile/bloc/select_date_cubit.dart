import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedDateCubit extends Cubit<DateTime?> {
  SelectedDateCubit() : super(null);

  void selectDate(DateTime date) {
    emit(date);
  }
}
