import '../../../domain/entities/auth/user.dart';

abstract class AttendanceStudentState {}

class AttendanceStudentInitial extends AttendanceStudentState {}

class AttendanceStudentLoading extends AttendanceStudentState {}

class AttendanceStudentLoaded extends AttendanceStudentState {
  final List<UserEntity> students;
  AttendanceStudentLoaded({required this.students});
}

class AttendanceStudentFailure extends AttendanceStudentState {}
