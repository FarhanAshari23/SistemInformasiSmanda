import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../bloc/bar_days_cubit.dart';
import '../bloc/jadwal_display_cubit.dart';
import '../views/profile_student_schedule_view.dart';
import '../views/profile_teacher_schedule_view.dart';

class JadwalDaysSelection extends StatelessWidget {
  final bool isTeacherSchedule;
  const JadwalDaysSelection({
    super.key,
    this.isTeacherSchedule = false,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<String> dayName = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          height: height * 0.1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dayName.length,
            padding: EdgeInsets.symmetric(horizontal: width * 0.035),
            itemBuilder: (context, index) => CustomInkWell(
              onTap: () {
                context.read<BarDaysCubit>().changeColor(index);
                if (!isTeacherSchedule) {
                  context
                      .read<JadwalDisplayCubit>()
                      .displayJadwal(params: dayName[index]);
                }
              },
              defaultColor: context.watch<BarDaysCubit>().state == index
                  ? AppColors.primary
                  : AppColors.inversePrimary,
              child: SizedBox(
                width: width * 0.1825,
                height: height * 0.1,
                child: Center(
                  child: Text(
                    dayName[index],
                    style: TextStyle(
                      color: context.watch<BarDaysCubit>().state == index
                          ? AppColors.inversePrimary
                          : AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: height * 0.02),
        Builder(builder: (context) {
          final selectedDay = dayName[context.watch<BarDaysCubit>().state];
          return Expanded(
            child: isTeacherSchedule
                ? ProfileTeacherScheduleView(hari: selectedDay)
                : ProfileStudentScheduleView(hari: selectedDay),
          );
        }),
      ],
    );
  }
}
