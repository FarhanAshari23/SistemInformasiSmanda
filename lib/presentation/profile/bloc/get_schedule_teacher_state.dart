import '../../../domain/entities/schedule/day.dart';

abstract class GetScheduleTeacherState {}

class GetScheduleTeacherLoading extends GetScheduleTeacherState {}

class GetScheduleTeacherLoaded extends GetScheduleTeacherState {
  List<DayEntity> teacherSchedule;
  GetScheduleTeacherLoaded({
    required this.teacherSchedule,
  });
}

class GetScheduleTeacherFailure extends GetScheduleTeacherState {
  final String errorMessage;

  GetScheduleTeacherFailure({required this.errorMessage});
}
