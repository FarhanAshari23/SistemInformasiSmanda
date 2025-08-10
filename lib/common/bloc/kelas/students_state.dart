import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';

abstract class StudentsDisplayState {}

class StudentsDisplayInitial extends StudentsDisplayState {}

class StudentsDisplayLoading extends StudentsDisplayState {}

class StudentsDisplayLoaded extends StudentsDisplayState {
  final List<UserEntity> students;
  StudentsDisplayLoaded({required this.students});
}

class StudentsDisplayFailure extends StudentsDisplayState {}
