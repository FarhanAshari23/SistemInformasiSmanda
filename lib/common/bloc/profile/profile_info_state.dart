import '../../../domain/entities/auth/teacher.dart';
import '../../../domain/entities/auth/user.dart';

abstract class ProfileInfoState {}

class ProfileInfoLoading extends ProfileInfoState {}

class ProfileInfoLoaded extends ProfileInfoState {
  UserEntity? userEntity;
  TeacherEntity? teacherEntity;
  ProfileInfoLoaded({
    this.userEntity,
    this.teacherEntity,
  });
}

class ProfileInfoFailure extends ProfileInfoState {}
