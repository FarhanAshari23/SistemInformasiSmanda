import 'package:flutter_bloc/flutter_bloc.dart';

class SelectTimestampCubit extends Cubit<DateTime?> {
  SelectTimestampCubit() : super(null);

  void select(DateTime time) {
    emit(time);
  }

  void reset() {
    emit(null);
  }
}
