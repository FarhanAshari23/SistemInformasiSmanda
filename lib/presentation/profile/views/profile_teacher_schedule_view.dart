import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/bloc/get_schedule_teacher_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/bloc/get_schedule_teacher_state.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/widgets/card_jadwal.dart';

import '../../../common/helper/parse_time_schedule.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/teacher/schedule_teacher.dart';

class ProfileTeacherScheduleView extends StatelessWidget {
  final String hari;
  const ProfileTeacherScheduleView({
    super.key,
    required this.hari,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return BlocBuilder<GetScheduleTeacherCubit, GetScheduleTeacherState>(
      builder: (context, state) {
        if (state is GetScheduleTeacherLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is GetScheduleTeacherLoaded) {
          if (state.teacherSchedule.isEmpty) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_busy_rounded,
                  color: AppColors.primary,
                  size: 48,
                ),
                SizedBox(height: 4),
                Text(
                  'Tidak ada jadwal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ],
            );
          } else {
            List<ScheduleTeacherEntity> scheduleByDay = state.teacherSchedule
                .where((element) => element.hari == hari)
                .toList();
            scheduleByDay.sort(
              (a, b) {
                final startA = parseTimeSchedule(a.jam);
                final startB = parseTimeSchedule(b.jam);
                return startA.compareTo(startB);
              },
            );
            if (scheduleByDay.isEmpty) {
              return const Center(child: Text("Tidak mengajar di hari ini"));
            } else {
              return ListView.separated(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemBuilder: (context, index) {
                  final item = scheduleByDay[index];
                  return CardJadwal(
                    jam: item.kelas,
                    kegiatan: item.kegiatan,
                    pelaksana: item.jam,
                    urutan: index + 1,
                    isTeacher: true,
                  );
                },
                separatorBuilder: (context, index) => SizedBox(
                  height: height * 0.01,
                ),
                itemCount: scheduleByDay.length,
              );
            }
          }
        }
        if (state is GetScheduleTeacherFailure) {
          return Container();
        }
        return Container();
      },
    );
  }
}
