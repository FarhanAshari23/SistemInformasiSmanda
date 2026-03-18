import '../../../domain/entities/teacher/teacher.dart';

abstract class TeacherState {}

class TeacherLoading extends TeacherState {}

class TeacherListLoaded extends TeacherState {
  final List<TeacherEntity> teachers;
  TeacherListLoaded({required this.teachers});
}

class TeacherLoaded extends TeacherState {
  final TeacherEntity teacher;
  TeacherLoaded({required this.teacher});
}

class TeacherFailure extends TeacherState {
  final String errorMessage;
  TeacherFailure({required this.errorMessage});
}
