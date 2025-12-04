import 'package:new_sistem_informasi_smanda/domain/entities/teacher/teacher.dart';

abstract class KepalaSekolahState {}

class KepalaSekolahLoading extends KepalaSekolahState {}

class KepalaSekolahLoaded extends KepalaSekolahState {
  final List<TeacherEntity> teacher;
  KepalaSekolahLoaded({required this.teacher});
}

class KepalaSekolahFailure extends KepalaSekolahState {
  final String errorMessage;
  KepalaSekolahFailure({required this.errorMessage});
}
