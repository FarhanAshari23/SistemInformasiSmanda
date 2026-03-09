import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/teacher/role.dart';

class SelectJabatanCubit extends Cubit<List<RoleEntity>> {
  SelectJabatanCubit() : super([]);

  void toggleJabatan(RoleEntity activity) {
    final current = List<RoleEntity>.from(state);

    final index = current.indexWhere((element) => element.id == activity.id);

    if (index != -1) {
      current.removeAt(index);
    } else {
      current.add(activity);
    }

    emit(current);
  }
}
