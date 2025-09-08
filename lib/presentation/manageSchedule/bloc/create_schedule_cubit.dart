import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/data/models/schedule/day.dart';

import 'create_schedule_state.dart';

class CreateScheduleCubit extends Cubit<CreateScheduleState> {
  CreateScheduleCubit()
      : super(
          CreateScheduleState(
            schedules: {
              "Senin": [],
              "Selasa": [],
              "Rabu": [],
              "Kamis": [],
              "Jumat": [],
            },
          ),
        );

  void addSchedule(
    String day,
    String pelaksana,
    String kegiatan,
    String durasi,
  ) {
    final updated = Map<String, List<DayModel>>.from(state.schedules);
    updated[day] = [
      ...updated[day]!,
      DayModel(jam: durasi, kegiatan: kegiatan, pelaksana: pelaksana)
    ];
    emit(state.copyWith(schedules: updated));
  }

  void editActivity(
    String day,
    int index,
    String pelaksana,
    String kegiatan,
    String durasi,
  ) {
    final updated = Map<String, List<DayModel>>.from(state.schedules);
    final schedules = List<DayModel>.from(updated[day]!);
    schedules[index] = DayModel(
        jam: durasi,
        kegiatan: kegiatan,
        pelaksana: pelaksana); // ganti dengan nama baru
    updated[day] = schedules;
    emit(state.copyWith(schedules: updated));
  }
}
