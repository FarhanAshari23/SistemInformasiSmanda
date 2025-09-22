import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button.cubit.dart';
import 'package:new_sistem_informasi_smanda/common/bloc/button/button_state.dart';
import 'package:new_sistem_informasi_smanda/common/widget/button/basic_button.dart';
import 'package:new_sistem_informasi_smanda/presentation/auth/views/login_view.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/bloc/bar_days_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/bloc/section_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/screen/jadwal.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/screen/qr_screen.dart';

import 'package:new_sistem_informasi_smanda/presentation/profile/widgets/card_profile.dart';
import '../../../common/helper/app_navigation.dart';
import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/usecases/auth/logout.dart';
import '../bloc/jadwal_display_cubit.dart';
import '../bloc/profile_info_cubit.dart';
import '../bloc/profile_info_state.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => BarDaysCubit()),
          BlocProvider(create: (context) => ProfileInfoCubit()..getUser()),
          BlocProvider(create: (context) => TwoContainersCubit()),
          BlocProvider(
            create: (context) => JadwalDisplayCubit()..displayJadwal(),
          ),
        ],
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: height * 0.155,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: height * 0.09,
                      color: AppColors.secondary,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                width: width * 0.125,
                                height: height * 0.06,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.tertiary,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: AppColors.inversePrimary,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      backgroundColor: AppColors.secondary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: SizedBox(
                                        height: height * 0.565,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: Column(
                                            children: [
                                              Image.asset(
                                                AppImages.splashLogout,
                                              ),
                                              SizedBox(height: height * 0.02),
                                              const Text(
                                                'Apakah Anda Yakin Ingin Keluar dari Aplikasi?',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color:
                                                      AppColors.inversePrimary,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              SizedBox(height: height * 0.02),
                                              BlocProvider(
                                                create: (context) =>
                                                    ButtonStateCubit(),
                                                child: BlocListener<
                                                    ButtonStateCubit,
                                                    ButtonState>(
                                                  listener: (context, state) {
                                                    if (state
                                                        is ButtonSuccessState) {
                                                      AppNavigator
                                                          .pushReplacement(
                                                              context,
                                                              LoginView());
                                                    }
                                                    if (state
                                                        is ButtonFailureState) {
                                                      var snackbar = SnackBar(
                                                        content: Text(
                                                            state.errorMessage),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                      );
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackbar);
                                                    }
                                                  },
                                                  child: Builder(
                                                      builder: (context) {
                                                    return BasicButton(
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                                ButtonStateCubit>()
                                                            .execute(
                                                              usecase:
                                                                  LogoutUsecase(),
                                                            );
                                                      },
                                                      title: 'Keluar',
                                                    );
                                                  }),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: width * 0.125,
                                height: height * 0.06,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColors.tertiary,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.logout,
                                    color: AppColors.inversePrimary,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: width * 0.4,
                      child: Image.asset(
                        AppImages.logoSMA,
                        width: width * 0.2,
                        height: height * 0.095,
                      ),
                    ),
                  ],
                ),
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
                                      user: state.userEntity,
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
                                          child: BlocBuilder<TwoContainersCubit,
                                              TwoContainersState>(
                                            builder: (context, state) {
                                              return AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                width: state ==
                                                        TwoContainersState
                                                            .containerOneSelected
                                                    ? width * 0.135
                                                    : width * 0.1,
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
                                                        ? const Radius.circular(
                                                            12)
                                                        : const Radius.circular(
                                                            0),
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
                                          child: BlocBuilder<TwoContainersCubit,
                                              TwoContainersState>(
                                            builder: (context, state) {
                                              return AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                width: state ==
                                                        TwoContainersState
                                                            .containerTwoSelected
                                                    ? width * 0.135
                                                    : width * 0.1,
                                                height: height * 0.055,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: state ==
                                                            TwoContainersState
                                                                .containerTwoSelected
                                                        ? const Radius.circular(
                                                            12)
                                                        : const Radius.circular(
                                                            0),
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
                                          ? const JadwalScreen()
                                          : QrScreen(
                                              qrCodeData:
                                                  state.userEntity.nisn!);
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
    );
  }
}
