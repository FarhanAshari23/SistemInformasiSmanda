import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/ekskul/ekskul.dart';

class SelectEkskulCubit extends Cubit<List<EkskulEntity>> {
  SelectEkskulCubit() : super([]);

  void toggleEkskul(EkskulEntity ekskul) {
    final current = List<EkskulEntity>.from(state);

    if (current.contains(ekskul)) {
      current.remove(ekskul); // kalau sudah ada → hapus
    } else {
      current.add(ekskul); // kalau belum ada → tambah
    }

    emit(current);
  }

  void setInitialSelected(List<EkskulEntity> selectedEkskul) {
    emit(List<EkskulEntity>.from(selectedEkskul));
  }
}
