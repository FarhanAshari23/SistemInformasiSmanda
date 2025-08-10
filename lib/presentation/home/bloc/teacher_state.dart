import 'package:new_sistem_informasi_smanda/domain/entities/auth/teacher.dart';

abstract class TeacherState {}

class TeacherLoading extends TeacherState {}

class TeacherLoaded extends TeacherState {
  final List<TeacherEntity> teacher;
  TeacherLoaded({required this.teacher});
}

class TeacherFailure extends TeacherState {
  final String errorMessage;
  TeacherFailure({required this.errorMessage});
}
