import 'package:flutter_bloc/flutter_bloc.dart';

class LogoutStateCubit extends Cubit<int> {
  LogoutStateCubit() : super(0);

  void changeState(int index) => emit(index);
}
