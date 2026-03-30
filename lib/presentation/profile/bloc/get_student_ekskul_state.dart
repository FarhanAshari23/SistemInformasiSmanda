import '../../../domain/entities/ekskul/member.dart';

abstract class GetStudentEkskulState {}

class GetStudentEkskulLoading extends GetStudentEkskulState {}

class GetStudentEkskulLoaded extends GetStudentEkskulState {
  final List<MemberEntity> ekskuls;

  GetStudentEkskulLoaded({required this.ekskuls});
}

class GetStudentEkskulFailure extends GetStudentEkskulState {
  final String errorMessage;

  GetStudentEkskulFailure({
    required this.errorMessage,
  });
}
