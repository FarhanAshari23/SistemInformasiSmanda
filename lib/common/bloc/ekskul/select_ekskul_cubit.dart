import 'package:flutter_bloc/flutter_bloc.dart';

class SelectEkskulCubit extends Cubit<List<String>> {
  SelectEkskulCubit() : super([]);

  void toggleEkskul(String ekskul) {
    final current = List<String>.from(state);

    if (current.contains(ekskul)) {
      current.remove(ekskul); // kalau sudah ada → hapus
    } else {
      current.add(ekskul); // kalau belum ada → tambah
    }

    emit(current);
  }

  void setInitialSelected(List<String> selectedEkskul) {
    emit(List<String>.from(selectedEkskul));
  }
}
