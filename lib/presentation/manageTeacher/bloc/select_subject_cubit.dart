import 'package:flutter_bloc/flutter_bloc.dart';

class SelectSubjectCubit extends Cubit<List<String>> {
  SelectSubjectCubit() : super([]);

  void toggleSubject(String subject) {
    final current = List<String>.from(state);

    if (current.contains(subject)) {
      current.remove(subject); // kalau sudah ada → hapus
    } else {
      current.add(subject); // kalau belum ada → tambah
    }

    emit(current);
  }
}
