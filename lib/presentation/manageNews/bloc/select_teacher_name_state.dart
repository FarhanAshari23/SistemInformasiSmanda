import '../../../domain/entities/teacher/teacher_golang.dart';

abstract class GetTeacherNameState {}

class GetTeacherNameInitial extends GetTeacherNameState {}

class GetTeacherNameLoading extends GetTeacherNameState {}

class GetTeacherNameLoaded extends GetTeacherNameState {
  final List<TeacherGolangEntity> teachers;
  GetTeacherNameLoaded({required this.teachers});
}

class GetTeacherNameFailure extends GetTeacherNameState {
  final String errorMessage;

  GetTeacherNameFailure({required this.errorMessage});
}
