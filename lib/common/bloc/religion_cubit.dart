import 'package:flutter_bloc/flutter_bloc.dart';

class ReligionCubit extends Cubit<String?> {
  ReligionCubit() : super(null);

  // Daftar pilihan (bisa juga dari API)
  final List<String> items = [
    "Islam",
    "Kristen Protestan",
    "Kristen Katolik",
    "Hindu",
    "Buddha",
    'Konghucu'
  ];

  void selectItem(String? value) {
    emit(value);
  }
}
