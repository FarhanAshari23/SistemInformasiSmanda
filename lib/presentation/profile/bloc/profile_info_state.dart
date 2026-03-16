import '../../../domain/entities/student/student.dart';
import '../../../domain/entities/teacher/teacher.dart';

abstract class ProfileInfoState {}

class ProfileInfoLoading extends ProfileInfoState {}

class ProfileInfoLoaded extends ProfileInfoState {
  StudentEntity? userEntity;
  TeacherEntity? teacherEntity;
  ProfileInfoLoaded({
    this.userEntity,
    this.teacherEntity,
  });
}

class ProfileInfoFailure extends ProfileInfoState {}
