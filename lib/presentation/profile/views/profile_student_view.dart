import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button.cubit.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button_state.dart';
import 'package:new_sistem_informasi_smanda/presentation/auth/views/login_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/bloc/bar_days_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/bloc/section_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/widgets/jadwal_days_selection.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/views/profile_student_qr_view.dart';

import 'package:new_sistem_informasi_smanda/presentation/profile/widgets/card_profile.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../common/widget/appbar/basic_appbar.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../bloc/jadwal_display_cubit.dart';
import '../bloc/profile_info_cubit.dart';
import '../bloc/profile_info_state.dart';

class ProfileStudentView extends StatelessWidget {
  const ProfileStudentView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BarDaysCubit()),
        BlocProvider(
            create: (context) => ProfileInfoCubit()..getUser("Students")),
        BlocProvider(create: (context) => TwoContainersCubit()),
        BlocProvider(
          create: (context) => JadwalDisplayCubit()..displayJadwal(),
        ),
        BlocProvider(
          create: (context) => ButtonStateCubit(),
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
                const BasicAppbar(
                  isBackViewed: true,
                  isLogout: true,
                  isProfileViewed: false,
                ),
                Expanded(
                  child: Column(
                    children: [
                      BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
                        builder: (context, state) {
                          if (state is ProfileInfoLoading) {
                            return Container(
                              width: double.infinity,
                              height: height * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: AppColors.secondary,
                              ),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CardProfile(
                                        student: state.userEntity,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              context
                                                  .read<TwoContainersCubit>()
                                                  .selectContainerOne();
                                            },
                                            child: BlocBuilder<
                                                TwoContainersCubit,
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
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          const Radius.circular(
                                                              12),
                                                      bottomLeft: state ==
                                                              TwoContainersState
                                                                  .containerOneSelected
                                                          ? const Radius
                                                              .circular(12)
                                                          : const Radius
                                                              .circular(0),
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
                                                          ? AppColors
                                                              .inversePrimary
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
                                            child: BlocBuilder<
                                                TwoContainersCubit,
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
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft: state ==
                                                              TwoContainersState
                                                                  .containerTwoSelected
                                                          ? const Radius
                                                              .circular(12)
                                                          : const Radius
                                                              .circular(0),
                                                      bottomLeft:
                                                          const Radius.circular(
                                                              12),
                                                    ),
                                                    color: state ==
                                                            TwoContainersState
                                                                .containerTwoSelected
                                                        ? AppColors.primary
                                                        : AppColors.secondary,
                                                  ),
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.qr_code,
                                                      color: state ==
                                                              TwoContainersState
                                                                  .containerTwoSelected
                                                          ? AppColors
                                                              .inversePrimary
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
                                            : ProfileStudentQrView(
                                                qrCodeData:
                                                    state.userEntity?.nisn ??
                                                        '');
                                      }),
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                          return Container();
                        },
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
