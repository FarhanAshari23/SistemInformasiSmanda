import 'package:flutter_bloc/flutter_bloc.dart';

class ReligionCubit extends Cubit<String?> {
  ReligionCubit() : super(null);

  final List<String> items = [
    "Islam",
    "Kristen Protestan",
    "Kristen Katolik",
    "Hindu",
    "Buddha",
    'Konghucu'
  ];

  void selectItem(String? value) {
    if (value != null) {
      emit(value);
    }
  }
}
