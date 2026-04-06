import 'package:flutter_bloc/flutter_bloc.dart';

class NewsNavigationCubit extends Cubit<int> {
  NewsNavigationCubit() : super(0);

  void changeColor(int index) => emit(index);
}
