import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/ekskul/ekskul.dart';

class SelectEkskulCubit extends Cubit<List<EkskulEntity>> {
  SelectEkskulCubit() : super([]);

  void toggleJabatan(EkskulEntity ekskul) {
    final current = List<EkskulEntity>.from(state);

    final index = current.indexWhere((element) => element.id == ekskul.id);

    if (index != -1) {
      current.removeAt(index);
    } else {
      current.add(ekskul);
    }

    emit(current);
  }
}
