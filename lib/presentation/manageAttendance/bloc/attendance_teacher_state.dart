import '../../../domain/entities/attandance/attandance_teacher.dart';

abstract class AttendanceTeacherState {}

class AttendanceTeacherLoading extends AttendanceTeacherState {}

class AttendanceTeacherLoaded extends AttendanceTeacherState {
  final List<AttandanceTeacherEntity> teachers;

  AttendanceTeacherLoaded({required this.teachers});
}

class AttendanceTeacherFailure extends AttendanceTeacherState {
  final String errorMessage;

  AttendanceTeacherFailure({required this.errorMessage});
}
