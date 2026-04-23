import 'package:flutter_bloc/flutter_bloc.dart';

class ListIndexCubit extends Cubit<int> {
  ListIndexCubit() : super(0);

  void classNavigation(int index) => emit(index);
}
