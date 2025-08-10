import 'package:new_sistem_informasi_smanda/domain/entities/auth/teacher.dart';

abstract class WakaState {}

class WakaLoading extends WakaState {}

class WakaLoaded extends WakaState {
  final List<TeacherEntity> teacher;
  WakaLoaded({required this.teacher});
}

class WakaFailure extends WakaState {
  final String errorMessage;
  WakaFailure({required this.errorMessage});
}
