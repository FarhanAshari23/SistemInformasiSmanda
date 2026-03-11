import '../../../domain/entities/teacher/teacher.dart';

abstract class GetTeacherNameState {}

class GetTeacherNameInitial extends GetTeacherNameState {}

class GetTeacherNameLoading extends GetTeacherNameState {}

class GetTeacherNameLoaded extends GetTeacherNameState {
  final List<TeacherEntity> teachers;
  GetTeacherNameLoaded({required this.teachers});
}

class GetTeacherNameFailure extends GetTeacherNameState {
  final String errorMessage;

  GetTeacherNameFailure({required this.errorMessage});
}
