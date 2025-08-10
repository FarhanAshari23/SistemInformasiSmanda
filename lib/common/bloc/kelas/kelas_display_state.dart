import 'package:cloud_firestore/cloud_firestore.dart';

abstract class KelasDisplayState {}

class KelasDisplayLoading extends KelasDisplayState {}

class KelasDisplayLoaded extends KelasDisplayState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> kelas;
  KelasDisplayLoaded({required this.kelas});
}

class KelasDisplayFailure extends KelasDisplayState {
  final String message;

  KelasDisplayFailure({required this.message});
}
