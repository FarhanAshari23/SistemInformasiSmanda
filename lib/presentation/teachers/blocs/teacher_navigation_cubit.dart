import 'package:flutter_bloc/flutter_bloc.dart';

class TeacherNavigationCubit extends Cubit<int> {
  TeacherNavigationCubit() : super(0);

  void changeColor(int index) => emit(index);
}
