import 'package:new_sistem_informasi_smanda/data/models/schedule/day.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/schedule/day.dart';

class CreateScheduleState {
  final Map<String, List<DayModel>> schedules;

  CreateScheduleState({required this.schedules});

  CreateScheduleState copyWith({Map<String, List<DayModel>>? schedules}) {
    return CreateScheduleState(
      schedules: schedules ?? this.schedules,
    );
  }
}
