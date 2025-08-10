import 'package:flutter_bloc/flutter_bloc.dart';

class BarDaysCubit extends Cubit<int> {
  BarDaysCubit() : super(0);

  void changeColor(int index) => emit(index);
}
