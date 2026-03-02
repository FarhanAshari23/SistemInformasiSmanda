import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user_golang.dart';

abstract class StudentsDisplayState {}

class StudentsDisplayInitial extends StudentsDisplayState {}

class StudentsDisplayLoading extends StudentsDisplayState {}

class StudentsDisplayLoaded extends StudentsDisplayState {
  final List<UserEntity> students;
  StudentsDisplayLoaded({required this.students});
}

class StudentsDisplayLoadedGolang extends StudentsDisplayState {
  final List<UserGolang> students;
  StudentsDisplayLoadedGolang({required this.students});
}

class StudentsDisplayFailure extends StudentsDisplayState {
  final String errorMessage;

  StudentsDisplayFailure({required this.errorMessage});
}
