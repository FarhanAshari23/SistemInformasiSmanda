import 'package:new_sistem_informasi_smanda/domain/entities/schedule/day.dart';

class CreateScheduleState {
  final Map<String, List<DayEntity>> schedules;

  CreateScheduleState({required this.schedules});

  CreateScheduleState copyWith({Map<String, List<DayEntity>>? schedules}) {
    return CreateScheduleState(
      schedules: schedules ?? this.schedules,
    );
  }
}
