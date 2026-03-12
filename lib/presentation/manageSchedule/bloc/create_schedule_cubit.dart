import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/schedule/day.dart';

import 'create_schedule_state.dart';

class CreateScheduleCubit extends Cubit<CreateScheduleState> {
  CreateScheduleCubit({Map<String, List<DayEntity>>? initialSchedules})
      : super(
          CreateScheduleState(
            schedules: initialSchedules ??
                {
                  "Senin": [],
                  "Selasa": [],
                  "Rabu": [],
                  "Kamis": [],
                  "Jumat": [],
                },
          ),
        );

  void addActivity(
    String? day,
    String? startTime,
    String? endTime,
    int? teacherId,
    int? subjectId,
  ) {
    final updated = Map<String, List<DayEntity>>.from(state.schedules);
    updated[day!] = [
      ...updated[day]!,
      DayEntity(
        day: day,
        endTime: endTime,
        startTime: startTime,
        subjectId: subjectId,
        teacherId: teacherId,
      )
    ];
    emit(state.copyWith(schedules: updated));
  }

  void deleteActivity(String day, int index) {
    final updated = Map<String, List<DayEntity>>.from(state.schedules);

    if (!updated.containsKey(day)) return;
    final currentList = updated[day];
    if (currentList == null || currentList.isEmpty) return;
    if (index < 0 || index >= currentList.length) return;

    final newList = List<DayEntity>.from(currentList)..removeAt(index);
    updated[day] = newList;

    emit(state.copyWith(schedules: updated));
  }

  void editActivity(
    String? day,
    int index,
    String? startTime,
    String? endTime,
    int? teacherId,
    int? subjectId,
    int? classId,
  ) {
    final updated = Map<String, List<DayEntity>>.from(state.schedules);
    final schedules = List<DayEntity>.from(updated[day]!);
    schedules[index] = DayEntity(
      classId: classId,
      day: day,
      endTime: endTime,
      startTime: startTime,
      subjectId: subjectId,
      teacherId: teacherId,
    );
    updated[day!] = schedules;
    emit(state.copyWith(schedules: updated));
  }
}
