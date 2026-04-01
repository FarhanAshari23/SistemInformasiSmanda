import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/schedule/day.dart';
import '../../../presentation/profile/widgets/card_jadwal.dart';
import '../../bloc/schedule/jadwal_display_cubit.dart';
import '../../bloc/schedule/jadwal_display_state.dart';
import '../appbar/basic_appbar.dart';

class TeacherScheduleDetail extends StatelessWidget {
  final int teacherId;
  const TeacherScheduleDetail({
    super.key,
    required this.teacherId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            JadwalDisplayCubit()..displayJadwalGuru(params: teacherId),
        child: SafeArea(
          child: Column(
            children: [
              const BasicAppbar(isBackViewed: true),
              Expanded(
                child: BlocBuilder<JadwalDisplayCubit, JadwalDisplayState>(
                  builder: (context, state) {
                    if (state is JadwalDisplayLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is JadwalDisplayLoaded) {
                      // 1. Definisikan list hari yang ingin ditampilkan
                      final List<String> days = [
                        "Senin",
                        "Selasa",
                        "Rabu",
                        "Kamis",
                        "Jumat"
                      ];

                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: days.length,
                        itemBuilder: (context, index) {
                          final dayName = days[index];

                          // 2. Filter data berdasarkan hari saat ini dalam loop
                          final schedulesByDay = state.jadwals
                              .where((element) => element.day == dayName)
                              .toList();

                          return _buildScheduleSection(dayName, schedulesByDay);
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleSection(String dayName, List<DayEntity> schedules) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: schedules.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, top: 16, bottom: 8),
            child: Text(
              dayName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        schedules.isNotEmpty
            ? ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: schedules.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final jadwal = schedules[index];
                  return CardJadwal(
                    jam: jadwal.className ?? '',
                    kegiatan: jadwal.subjectName ?? '',
                    pelaksana: "${jadwal.startTime} - ${jadwal.endTime}",
                    urutan: index + 1,
                    isTeacher: false,
                  );
                },
              )
            : const SizedBox(),
      ],
    );
  }
}
