import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widget/inkwell/custom_inkwell.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/bar_days_cubit.dart';
import '../views/student/profile_student_schedule_view.dart';
import '../views/teacher/profile_teacher_schedule_view.dart';

class JadwalDaysSelection extends StatelessWidget {
  final bool isTeacherSchedule;
  const JadwalDaysSelection({
    super.key,
    this.isTeacherSchedule = false,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
        SizedBox(height: height * 0.02),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            dayName.length,
            (index) {
              return CustomInkWell(
                onTap: () {
                  context.read<BarDaysCubit>().changeColor(index);
                },
                defaultColor: context.watch<BarDaysCubit>().state == index
                    ? AppColors.primary
                    : AppColors.inversePrimary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
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
              );
            },
          ),
        ),
        SizedBox(height: height * 0.02),
        Builder(builder: (context) {
          final selectedDay = dayName[context.watch<BarDaysCubit>().state];
          return Expanded(
            child: isTeacherSchedule
                ? ProfileTeacherScheduleView(
                    hari: selectedDay,
                  )
                : ProfileStudentScheduleView(hari: selectedDay),
          );
        }),
      ],
    );
  }
}
