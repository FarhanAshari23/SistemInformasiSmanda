import 'package:flutter_bloc/flutter_bloc.dart';

class PickerCubit extends Cubit<String> {
  PickerCubit() : super('hide');

  void show() => emit('show');

  void hide() => emit('hide');
}
