import '../../../domain/entities/student/student.dart';

abstract class StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final StudentEntity student;
  StudentLoaded({required this.student});
}

class StudentFailure extends StudentState {
  final String errorMessage;
  StudentFailure({required this.errorMessage});
}
