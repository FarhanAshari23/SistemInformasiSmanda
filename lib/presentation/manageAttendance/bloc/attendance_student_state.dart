import '../../../domain/entities/attandance/attendance_student.dart';

abstract class AttendanceStudentState {}

class AttendanceStudentInitial extends AttendanceStudentState {}

class AttendanceStudentLoading extends AttendanceStudentState {}

class AttendanceStudentLoaded extends AttendanceStudentState {
  final List<AttendanceStudentEntity> students;
  AttendanceStudentLoaded({required this.students});
}

class AttendanceStudentFailure extends AttendanceStudentState {
  final String errorMessage;

  AttendanceStudentFailure({required this.errorMessage});
}
