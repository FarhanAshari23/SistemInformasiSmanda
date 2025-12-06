import '../../../domain/entities/attandance/attandance.dart';

abstract class GetTeacherAttendanceState {}

class GetTeacherAttendanceLoading extends GetTeacherAttendanceState {}

class GetTeacherAttendanceLoaded extends GetTeacherAttendanceState {
  final List<AttandanceEntity> attendances;

  GetTeacherAttendanceLoaded({required this.attendances});
}

class GetTeacherAttendanceFailure extends GetTeacherAttendanceState {
  final String errorMessage;

  GetTeacherAttendanceFailure({
    required this.errorMessage,
  });
}
