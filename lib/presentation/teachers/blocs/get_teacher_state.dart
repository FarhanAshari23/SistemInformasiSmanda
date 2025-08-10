import 'package:new_sistem_informasi_smanda/domain/entities/auth/teacher.dart';

abstract class GetTeacherState {}

class GetTeacherInitial extends GetTeacherState {}

class GetTeacherLoading extends GetTeacherState {}

class GetTeacherLoaded extends GetTeacherState {
  final List<TeacherEntity> teachers;
  GetTeacherLoaded({required this.teachers});
}

class GetTeacherFailure extends GetTeacherState {}
