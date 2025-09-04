import 'package:flutter_bloc/flutter_bloc.dart';

class DurasiCubit extends Cubit<String?> {
  DurasiCubit() : super(null);

  final List<String> times = _generateTimes();

  void selectItem(String? value) {
    if (value != null) {
      emit(value);
    }
  }

  static List<String> _generateTimes() {
    List<String> result = [];
    DateTime start = DateTime(2023, 1, 1, 7, 15); // mulai 07:15
    DateTime end = DateTime(2023, 1, 1, 16, 0); // sampai 16:00

    while (start.isBefore(end) || start.isAtSameMomentAs(end)) {
      String formatted =
          "${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}";
      result.add(formatted);
      start = start.add(const Duration(minutes: 15));
    }
    return result;
  }
}
