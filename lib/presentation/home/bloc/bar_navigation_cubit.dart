import 'package:flutter_bloc/flutter_bloc.dart';

class BarNavigationCubit extends Cubit<int> {
  BarNavigationCubit() : super(0);

  void changeColor(int index) => emit(index);
}
