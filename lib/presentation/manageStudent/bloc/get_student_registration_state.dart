import '../../../domain/entities/auth/user.dart';

abstract class StudentsRegistrationState {}

class StudentsRegistrationInitial extends StudentsRegistrationState {}

class StudentsRegistrationLoading extends StudentsRegistrationState {}

class StudentsRegistrationLoaded extends StudentsRegistrationState {
  final List<UserEntity> students;
  StudentsRegistrationLoaded({required this.students});
}

class StudentsRegistrationFailure extends StudentsRegistrationState {}
