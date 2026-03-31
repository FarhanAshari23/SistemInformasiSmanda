import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/ekskul/ekskul.dart';

class SelectEkskulCubit extends Cubit<List<EkskulEntity>> {
  SelectEkskulCubit() : super([]);

  void toggleEkskul(EkskulEntity ekskul) {
    final current = List<EkskulEntity>.from(state);

    if (current.contains(ekskul)) {
      current.remove(ekskul);
    } else {
      current.add(ekskul);
    }

    emit(current);
  }

  void setInitialSelected(List<EkskulEntity> selectedEkskul) {
    emit(List<EkskulEntity>.from(selectedEkskul));
  }

  bool isSelected(EkskulEntity ekskul) {
    return state.any((e) => e.id == ekskul.id);
  }
}
