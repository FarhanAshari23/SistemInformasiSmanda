import 'package:cloud_firestore/cloud_firestore.dart';

abstract class KelasDisplayState {}

class KelasDisplayLoading extends KelasDisplayState {}

class KelasDisplayLoaded extends KelasDisplayState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> kelas;
  final String? selected;
  KelasDisplayLoaded({
    required this.kelas,
    this.selected,
  });

  KelasDisplayLoaded copyWith({
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? kelas,
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
