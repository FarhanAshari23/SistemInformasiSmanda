import 'package:new_sistem_informasi_smanda/domain/entities/kelas/kelas.dart';

abstract class KelasDisplayState {}

class KelasDisplayLoading extends KelasDisplayState {}

class KelasDisplayLoaded extends KelasDisplayState {
  final List<KelasEntity> kelas;
  final String? selected;
  KelasDisplayLoaded({
    required this.kelas,
    this.selected,
  });

  KelasDisplayLoaded copyWith({
    List<KelasEntity>? kelas,
    String? selected,
  }) {
    return KelasDisplayLoaded(
      kelas: kelas ?? this.kelas,
      selected: selected ?? this.selected,
    );
  }
}

class KelasDisplayFailure extends KelasDisplayState {
  final String message;

  KelasDisplayFailure({required this.message});
}
