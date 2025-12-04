import '../../../domain/entities/teacher/schedule_teacher.dart';

abstract class GetScheduleTeacherState {}

class GetScheduleTeacherLoading extends GetScheduleTeacherState {}

class GetScheduleTeacherLoaded extends GetScheduleTeacherState {
  List<ScheduleTeacherEntity> teacherSchedule;
  GetScheduleTeacherLoaded({
    required this.teacherSchedule,
  });
}

class GetScheduleTeacherFailure extends GetScheduleTeacherState {}
