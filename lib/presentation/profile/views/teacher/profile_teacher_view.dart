import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/bloc/teacher/teacher_cubit.dart';
import '../../../../common/bloc/teacher/teacher_state.dart';
import '../../bloc/bar_days_cubit.dart';
import '../../../../common/widget/appbar/basic_appbar.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../bloc/get_schedule_teacher_cubit.dart';
import '../../bloc/section_cubit.dart';
import '../../widgets/card_profile.dart';
import '../../widgets/jadwal_days_selection.dart';
import 'profile_teacher_menu_view.dart';

class ProfileTeacher extends StatelessWidget {
  final int teacherId;
  const ProfileTeacher({
    super.key,
    required this.teacherId,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TwoContainersCubit()),
        BlocProvider(create: (context) => BarDaysCubit()),
        BlocProvider(
          create: (context) =>
              GetScheduleTeacherCubit()..getJadwalGuru(teacherId),
        ),
        BlocProvider(
          create: (context) =>
              TeacherCubit()..displayTeacherById(params: teacherId),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<TeacherCubit, TeacherState>(
          builder: (context, teacherState) {
            if (teacherState is TeacherLoading) {
              return SafeArea(
                child: Column(
                  children: [
                    const BasicAppbar(
                      isBackViewed: false,
                      showLogo: true,
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: width * 0.015),
                      height: height * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.secondary,
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Silakan Tunggu Sebentar',
                              style: TextStyle(
                                color: AppColors.inversePrimary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (teacherState is TeacherLoaded) {
              return SafeArea(
                child: Column(
                  children: [
                    BasicAppbar(
                      isBackViewed: false,
                      teacher: teacherState.teacher,
                      showLogo: true,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CardProfile(
                                  teacher: teacherState.teacher,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(2, (index) {
                                  return BlocBuilder<TwoContainersCubit, int>(
                                    builder: (context, state) {
                                      final isSelected = state == index;

                                      return GestureDetector(
                                        onTap: () {
                                          context
                                              .read<TwoContainersCubit>()
                                              .selectIndex(index);
                                        },
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          width: isSelected
                                              ? width * 0.125
                                              : width * 0.09,
                                          height: height * 0.055,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: isSelected
                                                  ? const Radius.circular(12)
                                                  : const Radius.circular(0),
                                              bottomLeft: isSelected
                                                  ? const Radius.circular(12)
                                                  : const Radius.circular(0),
                                            ),
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.secondary,
                                          ),
                                          child: Center(
                                            child: Icon(
                                              _getIconForIndex(index),
                                              color: isSelected
                                                  ? AppColors.inversePrimary
                                                  : AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                              )
                            ],
                          ),
                          SizedBox(height: height * 0.01),
                          Expanded(
                            child: SizedBox(
                              child: Builder(builder: (context) {
                                return context
                                            .watch<TwoContainersCubit>()
                                            .state ==
                                        1
                                    ? const JadwalDaysSelection(
                                        isTeacherSchedule: true,
                                      )
                                    : ProfileTeacherMenuView(
                                        teacher: teacherState.teacher,
                                      );
                              }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            if (teacherState is TeacherFailure) {
              return Center(child: Text(teacherState.errorMessage));
            }
            return Container();
          },
        ),
      ),
    );
  }
}

IconData _getIconForIndex(int index) {
  switch (index) {
    case 0:
      return Icons.calendar_month;
    case 1:
      return Icons.apps;
    case 2:
    default:
      return Icons.task;
  }
}
