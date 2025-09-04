import 'package:new_sistem_informasi_smanda/domain/entities/auth/teacher.dart';

abstract class TeacherState {}

class TeacherLoading extends TeacherState {}

class TeacherLoaded extends TeacherState {
  final List<TeacherEntity> teacher;
  final String? selected;
  TeacherLoaded({required this.teacher, this.selected});

  TeacherLoaded copyWith({
    List<TeacherEntity>? teacher,
    String? selected,
  }) {
    return TeacherLoaded(
      teacher: teacher ?? this.teacher,
      selected: selected ?? this.selected,
    );
  }
}

class TeacherFailure extends TeacherState {
  final String errorMessage;
  TeacherFailure({required this.errorMessage});
}
