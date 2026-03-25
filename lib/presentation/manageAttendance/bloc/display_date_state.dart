import '../../../domain/entities/attandance/attandance_teacher.dart';
import '../../../domain/entities/attandance/attendance_student.dart';

abstract class DisplayDateState {}

class DisplayDateLoading extends DisplayDateState {}

class DisplayDateTeacherLoaded extends DisplayDateState {
  final List<AttandanceTeacherEntity> attendances;
  DisplayDateTeacherLoaded({required this.attendances});
}

class DisplayDateStudentLoaded extends DisplayDateState {
  final List<AttendanceStudentEntity> attendances;
  DisplayDateStudentLoaded({required this.attendances});
}

class DisplayDateFailure extends DisplayDateState {
  final String errorMessage;
  DisplayDateFailure({required this.errorMessage});
}
