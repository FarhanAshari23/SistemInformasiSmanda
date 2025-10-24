import 'package:flutter_bloc/flutter_bloc.dart';

class SelectJabatanCubit extends Cubit<List<String>> {
  SelectJabatanCubit() : super([]);

  void toggleJabatan(String jabatan) {
    final current = List<String>.from(state);

    if (current.contains(jabatan)) {
      current.remove(jabatan); // kalau sudah ada → hapus
    } else {
      current.add(jabatan); // kalau belum ada → tambah
    }

    emit(current);
  }
}
