import '../../../domain/entities/auth/user.dart';

abstract class StudentsNISNState {}

class StudentsNISNInitial extends StudentsNISNState {}

class StudentsNISNLoading extends StudentsNISNState {}

class StudentsNISNLoaded extends StudentsNISNState {
  final UserEntity student;
  StudentsNISNLoaded({required this.student});
}

class StudentsNISNFailure extends StudentsNISNState {}
