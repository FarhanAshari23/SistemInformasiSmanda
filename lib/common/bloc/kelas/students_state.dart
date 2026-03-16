import '../../../domain/entities/student/student.dart';

abstract class StudentsDisplayState {}

class StudentsDisplayInitial extends StudentsDisplayState {}

class StudentsDisplayLoading extends StudentsDisplayState {}

class StudentsDisplayLoaded extends StudentsDisplayState {
  final List<StudentEntity> students;
  StudentsDisplayLoaded({required this.students});
}

class StudentsDisplayFailure extends StudentsDisplayState {
  final String errorMessage;

  StudentsDisplayFailure({required this.errorMessage});
}
