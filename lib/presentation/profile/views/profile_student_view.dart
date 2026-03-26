import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:new_sistem_informasi_smanda/presentation/profile/widgets/card_profile.dart';
import '../../../common/bloc/button/button.cubit.dart';
import '../../../common/bloc/button/button_state.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/entities/student/student.dart';
import '../../auth/views/login_view.dart';
import '../bloc/bar_days_cubit.dart';
import '../bloc/get_attendance_student_cubit.dart';
import '../../../common/bloc/schedule/jadwal_display_cubit.dart';
import '../bloc/section_cubit.dart';
import '../widgets/jadwal_days_selection.dart';
import 'profile_student_qr_view.dart';

class ProfileStudentView extends StatelessWidget {
  final StudentEntity? student;
  const ProfileStudentView({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BarDaysCubit()),
        BlocProvider(create: (context) => TwoContainersCubit()),
        BlocProvider(
          create: (context) => JadwalDisplayCubit()..displayJadwal(),
        ),
        BlocProvider(
          create: (context) => ButtonStateCubit(),
        ),
        BlocProvider(
          create: (context) => GetStudentAttendanceCubit(),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) {
              if (state is ButtonSuccessState) {
                AppNavigator.pushReplacement(context, LoginView());
              }
              if (state is ButtonFailureState) {
                var snackbar = SnackBar(
                  content: Text(state.errorMessage),
                  behavior: SnackBarBehavior.floating,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },
            child: Column(
              children: [
                BasicAppbar(
                  isBackViewed: true,
                  isLogout: true,
                  student: student,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CardProfile(
                                  student: student,
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
                                                ? width * 0.125
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
                                                Icons.event,
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
                                                ? width * 0.125
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
                                                Icons.calendar_month,
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
                            SizedBox(height: height * 0.02),
                            Expanded(
                              child: SizedBox(
                                child: Builder(builder: (context) {
                                  return context
                                              .watch<TwoContainersCubit>()
                                              .state ==
                                          TwoContainersState
                                              .containerOneSelected
                                      ? const JadwalDaysSelection()
                                      : ProfileStudentQrView(student: student);
                                }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
