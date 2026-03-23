import '../../../domain/entities/attandance/attandance_teacher.dart';

abstract class DisplayDateState {}

class DisplayDateLoading extends DisplayDateState {}

class DisplayDateLoaded extends DisplayDateState {
  final List<AttandanceTeacherEntity> attendances;
  DisplayDateLoaded({required this.attendances});
}

class DisplayDateFailure extends DisplayDateState {
  final String errorMessage;
  DisplayDateFailure({required this.errorMessage});
}
