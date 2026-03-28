import '../../../domain/entities/attandance/attandance_teacher.dart';

abstract class GetTeacherAttendanceState {}

class GetTeacherAttendanceLoading extends GetTeacherAttendanceState {}

class GetTeacherAttendanceLoaded extends GetTeacherAttendanceState {
  final List<AttandanceTeacherEntity> attendances;

  GetTeacherAttendanceLoaded({required this.attendances});
}

class GetTeacherAttendanceCurrentLoaded extends GetTeacherAttendanceState {
  final AttandanceTeacherEntity attendance;

  GetTeacherAttendanceCurrentLoaded({required this.attendance});
}

class GetTeacherAttendanceFailure extends GetTeacherAttendanceState {
  final String errorMessage;

  GetTeacherAttendanceFailure({
    required this.errorMessage,
  });
}
