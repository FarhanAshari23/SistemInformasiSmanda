import '../../../domain/entities/teacher/teacher.dart';

abstract class AttendanceTeacherState {}

class AttendanceTeacherLoading extends AttendanceTeacherState {}

class AttendanceTeacherLoaded extends AttendanceTeacherState {
  final List<TeacherEntity> teachers;

  AttendanceTeacherLoaded({required this.teachers});
}

class AttendanceTeacherFailure extends AttendanceTeacherState {
  final String errorMessage;

  AttendanceTeacherFailure({required this.errorMessage});
}
