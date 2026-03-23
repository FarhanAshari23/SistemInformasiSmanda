import '../../../domain/entities/attandance/attendance_student.dart';

abstract class GetAttendanceStudentState {}

class GetAttendanceStudentLoading extends GetAttendanceStudentState {}

class GetAttendanceStudentLoaded extends GetAttendanceStudentState {
  final List<AttendanceStudentEntity> attendances;
  GetAttendanceStudentLoaded({required this.attendances});
}

class GetAttendanceStudentFailure extends GetAttendanceStudentState {
  final String errorMessage;

  GetAttendanceStudentFailure({required this.errorMessage});
}
