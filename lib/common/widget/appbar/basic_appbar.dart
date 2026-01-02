import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/common/helper/app_navigation.dart';
import 'package:new_sistem_informasi_smanda/common/helper/display_image.dart';
import 'package:new_sistem_informasi_smanda/common/helper/extract_name.dart';
import 'package:new_sistem_informasi_smanda/common/helper/get_first_name.dart';
import 'package:new_sistem_informasi_smanda/common/widget/inkwell/custom_inkwell.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/bloc/profile_info_cubit.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/bloc/profile_info_state.dart';
import 'package:new_sistem_informasi_smanda/presentation/profile/views/profile_student_view.dart';

import '../../../core/configs/assets/app_images.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../domain/usecases/auth/logout.dart';
import '../../../presentation/auth/views/login_view.dart';
import '../../bloc/button/button.cubit.dart';
import '../../bloc/button/button_state.dart';
import '../dialog/basic_dialog.dart';
import '../photo/network_photo.dart';

class BasicAppbar extends StatelessWidget {
  final bool isBackViewed;
  final bool isProfileViewed;
  final bool isProfileTeacherViewed;
  final bool? isLogout;
  const BasicAppbar({
    super.key,
    required this.isBackViewed,
    required this.isProfileViewed,
    this.isLogout,
    this.isProfileTeacherViewed = false,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    DateTime now = DateTime.now();
    String greeting;
    int hour = now.hour;
    if (hour < 10) {
      greeting = "Pagi";
    } else if (hour < 16) {
      greeting = "Siang";
    } else if (hour < 19) {
      greeting = "Sore";
    } else {
      greeting = "Malam";
    }
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProfileInfoCubit()),
        BlocProvider(
          create: (context) => ProfileInfoCubit()
            ..getUser(isProfileTeacherViewed ? "Teachers" : "Students"),
        ),
        BlocProvider(
          create: (context) => ButtonStateCubit(),
        ),
      ],
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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 48),
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            clipBehavior: Clip.none,
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
                      isBackViewed
                          ? CustomInkWell(
                              onTap: () => Navigator.pop(context),
                              borderRadius: 8,
                              defaultColor: AppColors.tertiary,
                              child: SizedBox(
                                width: width * 0.125,
                                height: height * 0.06,
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: AppColors.inversePrimary,
                                    size: 32,
                                  ),
                                ),
                              ),
                            )
                          : isProfileTeacherViewed
                              ? BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
                                  builder: (context, state) {
                                    if (state is ProfileInfoLoading) {
                                      return const Text(
                                        '...',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.inversePrimary,
                                        ),
                                      );
                                    }
                                    if (state is ProfileInfoLoaded) {
                                      String nickname = getFirstRealName(
                                          state.teacherEntity?.nama ?? '');
                                      return Text(
                                        'Selamat $greeting $nickname!',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.inversePrimary,
                                        ),
                                      );
                                    }
                                    return const Text("something error");
                                  },
                                )
                              : const SizedBox(),
                      isProfileViewed
                          ? BlocBuilder<ProfileInfoCubit, ProfileInfoState>(
                              builder: (context, state) {
                                if (state is ProfileInfoLoading) {
                                  return Row(
                                    children: [
                                      const Text(
                                        '...',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.inversePrimary,
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      GestureDetector(
                                        onTap: () => AppNavigator.push(
                                          context,
                                          const ProfileStudentView(),
                                        ),
                                        child: Container(
                                          width: width * 0.105,
                                          height: height * 0.065,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.tertiary,
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                if (state is ProfileInfoLoaded) {
                                  String nickname =
                                      extractName(state.userEntity?.nama ?? '');
                                  return Row(
                                    children: [
                                      Text(
                                        '$greeting $nickname!',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.inversePrimary,
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      GestureDetector(
                                        onTap: () => AppNavigator.push(
                                          context,
                                          const ProfileStudentView(),
                                        ),
                                        child: NetworkPhoto(
                                          width: width * 0.105,
                                          height: height * 0.065,
                                          shape: BoxShape.circle,
                                          fallbackAsset:
                                              state.userEntity?.gender == 1
                                                  ? AppImages.boyStudent
                                                  : AppImages.girlStudent,
                                          imageUrl:
                                              DisplayImage.displayImageStudent(
                                                  state.userEntity?.nama ?? '',
                                                  state.userEntity?.nisn ?? ''),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return Container();
                              },
                            )
                          : isLogout ?? false
                              ? Builder(builder: (outerContext) {
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return BasicDialog(
                                            width: width,
                                            height: height,
                                            buttonTitle: 'Keluar',
                                            mainTitle:
                                                'Apakah Anda Yakin Ingin Keluar dari Aplikasi?',
                                            splashImage: AppImages.splashLogout,
                                            onPressed: () {
                                              outerContext
                                                  .read<ButtonStateCubit>()
                                                  .execute(
                                                    usecase: LogoutUsecase(),
                                                  );
                                            },
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
                                  );
                                })
                              : const SizedBox(),
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
      ),
    );
  }
}
