import '../../../domain/entities/attandance/attandance.dart';

abstract class GetAttendanceStudentState {}

class GetAttendanceStudentLoading extends GetAttendanceStudentState {}

class GetAttendanceStudentLoaded extends GetAttendanceStudentState {
  final List<AttandanceEntity> attendances;
  GetAttendanceStudentLoaded({required this.attendances});
}

class GetAttendanceStudentFailure extends GetAttendanceStudentState {
  final String errorMessage;

  GetAttendanceStudentFailure({required this.errorMessage});
}
