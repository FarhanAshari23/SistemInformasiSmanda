import 'package:flutter_bloc/flutter_bloc.dart';

class TwoContainersCubit extends Cubit<int> {
  TwoContainersCubit() : super(0);
  void selectIndex(int index) => emit(index);
  void resetSelection() => emit(-1);
}
