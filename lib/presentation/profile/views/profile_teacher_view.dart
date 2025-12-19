import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bar_days_cubit.dart';
import '../bloc/get_schedule_teacher_cubit.dart';
import '../bloc/profile_info_cubit.dart';
import '../bloc/profile_info_state.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/section_cubit.dart';
import '../widgets/card_profile.dart';
import '../widgets/jadwal_days_selection.dart';
import 'profile_teacher_menu_view.dart';

class ProfileTeacher extends StatelessWidget {
  const ProfileTeacher({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileInfoCubit()..getUser("Teachers"),
        ),
        BlocProvider(create: (context) => TwoContainersCubit()),
        BlocProvider(
          create: (_) => GetScheduleTeacherCubit(),
        ),
        BlocProvider(create: (context) => BarDaysCubit()),
      ],
      child: BlocListener<ProfileInfoCubit, ProfileInfoState>(
        listener: (context, state) {
          if (state is ProfileInfoLoaded) {
            context
                .read<GetScheduleTeacherCubit>()
                .getScheduleTeacher(state.teacherEntity?.nama ?? '');
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              children: [
                const BasicAppbar(
                  isBackViewed: false,
                  isLogout: true,
                  isProfileViewed: false,
                  isProfileTeacherViewed: true,
                ),
                BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
                  builder: (context, state) {
                    if (state is ProfileInfoLoading) {
                      return Container(
                        width: double.infinity,
                        height: height * 0.2,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
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
                      );
                    }
                    if (state is ProfileInfoLoaded) {
                      return Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: width * 0.005),
                                  child: CardProfile(
                                    teacher: state.teacherEntity,
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        context
                                            .read<TwoContainersCubit>()
                                            .selectContainerOne();
                                      },
                                      child: BlocBuilder<TwoContainersCubit,
                                          TwoContainersState>(
                                        builder: (context, state) {
                                          return AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            width: state ==
                                                    TwoContainersState
                                                        .containerOneSelected
                                                ? width * 0.12
                                                : width * 0.09,
                                            height: height * 0.055,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(12),
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
                                          );
                                        },
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        context
                                            .read<TwoContainersCubit>()
                                            .selectContainerTwo();
                                      },
                                      child: BlocBuilder<TwoContainersCubit,
                                          TwoContainersState>(
                                        builder: (context, state) {
                                          return AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
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
                                                bottomLeft:
                                                    const Radius.circular(12),
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
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.01),
                            Expanded(
                              child: SizedBox(
                                child: Builder(builder: (context) {
                                  return context
                                              .watch<TwoContainersCubit>()
                                              .state ==
                                          TwoContainersState
                                              .containerOneSelected
                                      ? const JadwalDaysSelection(
                                          isTeacherSchedule: true,
                                        )
                                      : ProfileTeacherMenuView(
                                          teacher: state.teacherEntity!,
                                        );
                                }),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
