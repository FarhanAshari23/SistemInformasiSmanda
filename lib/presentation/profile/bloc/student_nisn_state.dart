import '../../../domain/entities/student/student.dart';

abstract class StudentsNISNState {}

class StudentsNISNInitial extends StudentsNISNState {}

class StudentsNISNLoading extends StudentsNISNState {}

class StudentsNISNLoaded extends StudentsNISNState {
  final StudentEntity student;
  StudentsNISNLoaded({required this.student});
}

class StudentsNISNFailure extends StudentsNISNState {}
