import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/bloc/get_schedule_teacher_cubit.dart';

import '../../../domain/entities/teacher/teacher.dart';
import '../bloc/bar_days_cubit.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/section_cubit.dart';
import '../widgets/card_profile.dart';
import '../widgets/jadwal_days_selection.dart';
import 'profile_teacher_menu_view.dart';

class ProfileTeacher extends StatelessWidget {
  final TeacherEntity teacher;
  const ProfileTeacher({
    super.key,
    required this.teacher,
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
              GetScheduleTeacherCubit()..getJadwalGuru(teacher.id ?? 0),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              BasicAppbar(
                isBackViewed: false,
                isLogout: true,
                teacher: teacher,
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: width * 0.005),
                          child: CardProfile(
                            teacher: teacher,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            BlocBuilder<TwoContainersCubit, TwoContainersState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap: () {
                                    context
                                        .read<TwoContainersCubit>()
                                        .selectContainerOne();
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: state ==
                                            TwoContainersState
                                                .containerOneSelected
                                        ? width * 0.12
                                        : width * 0.09,
                                    height: height * 0.055,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(12),
                                        bottomLeft: state ==
                                                TwoContainersState
                                                    .containerOneSelected
                                            ? const Radius.circular(12)
                                            : const Radius.circular(0),
                                      ),
                                      color: state ==
                                              TwoContainersState
                                                  .containerOneSelected
                                          ? AppColors.primary
                                          : AppColors.secondary,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.calendar_month,
                                        color: state ==
                                                TwoContainersState
                                                    .containerOneSelected
                                            ? AppColors.inversePrimary
                                            : AppColors.primary,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            BlocBuilder<TwoContainersCubit, TwoContainersState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap: () {
                                    context
                                        .read<TwoContainersCubit>()
                                        .selectContainerTwo();
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    width: state ==
                                            TwoContainersState
                                                .containerTwoSelected
                                        ? width * 0.12
                                        : width * 0.09,
                                    height: height * 0.055,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: state ==
                                                TwoContainersState
                                                    .containerTwoSelected
                                            ? const Radius.circular(12)
                                            : const Radius.circular(0),
                                        bottomLeft: const Radius.circular(12),
                                      ),
                                      color: state ==
                                              TwoContainersState
                                                  .containerTwoSelected
                                          ? AppColors.primary
                                          : AppColors.secondary,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.apps,
                                        color: state ==
                                                TwoContainersState
                                                    .containerTwoSelected
                                            ? AppColors.inversePrimary
                                            : AppColors.primary,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.01),
                    Expanded(
                      child: SizedBox(
                        child: Builder(builder: (context) {
                          return context.watch<TwoContainersCubit>().state ==
                                  TwoContainersState.containerOneSelected
                              ? const JadwalDaysSelection(
                                  isTeacherSchedule: true,
                                )
                              : ProfileTeacherMenuView(
                                  teacher: teacher,
                                );
                        }),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
