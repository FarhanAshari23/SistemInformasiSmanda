import '../../../domain/entities/ekskul/ekskul.dart';

abstract class EkskulState {}

class EkskulLoading extends EkskulState {}

class EkskulLoaded extends EkskulState {
  final List<EkskulEntity> ekskul;
  EkskulLoaded({required this.ekskul});
}

class EkskulFailure extends EkskulState {
  final String errorMessage;
  EkskulFailure({required this.errorMessage});
}
