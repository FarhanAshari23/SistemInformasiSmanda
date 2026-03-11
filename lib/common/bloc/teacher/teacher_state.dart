import '../../../domain/entities/teacher/teacher.dart';

abstract class TeacherState {}

class TeacherLoading extends TeacherState {}

class TeacherLoaded extends TeacherState {
  final List<TeacherEntity> teachers;
  final String? selected;
  final List<String> selectedActivities;
  TeacherLoaded({
    required this.teachers,
    this.selected,
    this.selectedActivities = const [],
  });

  TeacherLoaded copyWith({
    List<TeacherEntity>? teachers,
    String? selected,
    List<String>? selectedActivities,
  }) {
    return TeacherLoaded(
      teachers: teachers ?? this.teachers,
    );
  }
}

class TeacherFailure extends TeacherState {
  final String errorMessage;
  TeacherFailure({required this.errorMessage});
}
