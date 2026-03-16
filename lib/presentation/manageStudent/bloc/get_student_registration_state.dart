import '../../../domain/entities/student/student.dart';

abstract class StudentsRegistrationState {}

class StudentsRegistrationInitial extends StudentsRegistrationState {}

class StudentsRegistrationLoading extends StudentsRegistrationState {}

class StudentsRegistrationLoaded extends StudentsRegistrationState {
  final List<StudentEntity> students;
  StudentsRegistrationLoaded({required this.students});
}

class StudentsRegistrationFailure extends StudentsRegistrationState {
  final String errorMessage;

  StudentsRegistrationFailure({required this.errorMessage});
}
