class FormFieldsState {
  final String classValue;
  final String teacherValue;

  FormFieldsState({
    this.classValue = '',
    this.teacherValue = '',
  });

  bool get isClassEmpty => classValue.isEmpty;
  bool get isTeacherEmpty => teacherValue.isEmpty;

  FormFieldsState copyWith({
    String? classValue,
    String? teacherValue,
  }) {
    return FormFieldsState(
      classValue: classValue ?? this.classValue,
      teacherValue: teacherValue ?? this.teacherValue,
    );
  }
}
