import 'package:flutter_bloc/flutter_bloc.dart';

class KelasNavigationCubit extends Cubit<int> {
  KelasNavigationCubit() : super(0);

  void changeColor(int index) => emit(index);
}
