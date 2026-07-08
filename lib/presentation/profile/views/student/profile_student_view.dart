import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/bloc/button/button.cubit.dart';
import '../../../../common/bloc/button/button_state.dart';
import '../../../../common/bloc/student/get_student_cubit.dart';
import '../../../../common/bloc/student/get_student_state.dart';
import '../../../../common/helper/app_navigation.dart';
import '../../../../common/widget/button/basic_button.dart';
import '../../../../core/configs/assets/app_images.dart';
import '../../../../core/configs/theme/app_colors.dart';
import '../../../../domain/usecases/auth/logout.dart';
import '../../../auth/views/login_view.dart';
import '../../bloc/bar_days_cubit.dart';
import '../../bloc/get_attendance_student_cubit.dart';
import '../../../../common/bloc/schedule/jadwal_display_cubit.dart';
import '../../bloc/section_cubit.dart';
import '../../widgets/card_profile.dart';
import '../../widgets/jadwal_days_selection.dart';
import 'profile_student_attendance_view.dart';

class ProfileStudentView extends StatelessWidget {
  final int studentId;
  const ProfileStudentView({
    super.key,
    required this.studentId,
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
          create: (context) =>
              StudentCubit()..displayStudentById(params: studentId),
        ),
        BlocProvider(
          create: (context) => ButtonStateCubit(),
        ),
        BlocProvider(
          create: (context) =>
              GetStudentAttendanceCubit()..getAttendanceStudent(studentId),
        ),
      ],
      child: Scaffold(
        body: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonLoadingState) return;
            if (state is ButtonFailureState) {
              var snackbar = SnackBar(
                content: Text(state.errorMessage),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }
            if (state is ButtonSuccessState) {
              AppNavigator.pushReplacement(context, LoginView());
            }
          },
          child: Column(
            children: [
              BlocBuilder<StudentCubit, StudentState>(
                builder: (context, state) {
                  if (state is StudentLoading) {
                    return Container(
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
                    );
                  }
                  if (state is StudentLoaded) {
                    List<Widget> pages = [
                      const JadwalDaysSelection(),
                      ProfileStudentAttendanceView(student: state.student),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImages.splashLogout,
                            width: 300,
                            height: 300,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: BasicButton(
                              onPressed: () =>
                                  context.read<ButtonStateCubit>().execute(
                                        usecase: LogoutUsecase(),
                                      ),
                              title: "Keluar",
                            ),
                          ),
                        ],
                      ),
                    ];
                    return BlocProvider(
                      create: (context) => JadwalDisplayCubit()
                        ..displayJadwal(params: state.student.kelasId ?? 0),
                      child: Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CardProfile(
                                    student: state.student,
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: List.generate(3, (index) {
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
                                            duration: const Duration(
                                                milliseconds: 300),
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
                            SizedBox(height: height * 0.02),
                            Expanded(
                              child: SizedBox(
                                child: Builder(builder: (context) {
                                  return pages[context
                                      .watch<TwoContainersCubit>()
                                      .state];
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is StudentFailure) {
                    return Center(child: Text(state.errorMessage));
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

IconData _getIconForIndex(int index) {
  switch (index) {
    case 0:
      return Icons.event;
    case 1:
      return Icons.calendar_month;
    case 2:
      return Icons.logout_outlined;
    default:
      return Icons.crop_free;
  }
}
