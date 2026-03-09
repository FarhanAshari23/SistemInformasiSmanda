import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/kelas/kelas.dart';

class SelectKelasCubit extends Cubit<List<KelasEntity>> {
  SelectKelasCubit() : super([]);

  void toggleKelas(KelasEntity kelas) {
    final current = List<KelasEntity>.from(state);

    final index = current.indexWhere((element) => element.id == kelas.id);

    if (index != -1) {
      current.removeAt(index);
    } else {
      current.add(kelas);
    }

    emit(current);
  }

  void selectAll(List<KelasEntity> allKelas) {
    final allSelected = List<KelasEntity>.from(allKelas);
    emit(allSelected);
  }

  void clearAll() {
    emit([]);
  }
}
