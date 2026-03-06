import 'package:new_sistem_informasi_smanda/domain/entities/teacher/teacher.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/teacher/teacher_golang.dart';

abstract class TeacherState {}

class TeacherLoading extends TeacherState {}

class TeacherLoaded extends TeacherState {
  final List<TeacherEntity> teacher;
  final String? selected;
  final List<String> selectedActivities;
  TeacherLoaded({
    required this.teacher,
    this.selected,
    this.selectedActivities = const [],
  });

  TeacherLoaded copyWith({
    List<TeacherEntity>? teacher,
    String? selected,
    List<String>? selectedActivities,
  }) {
    return TeacherLoaded(
      teacher: teacher ?? this.teacher,
      selected: selected ?? this.selected,
      selectedActivities: selectedActivities ?? this.selectedActivities,
    );
  }
}

class TeacherGolangLoaded extends TeacherState {
  final List<TeacherGolangEntity> teachers;

  TeacherGolangLoaded({
    required this.teachers,
  });
}

class TeacherFailure extends TeacherState {
  final String errorMessage;
  TeacherFailure({required this.errorMessage});
}
